defmodule PulseOpsWeb do
  @moduledoc false
  def controller do
    quote do
      use Phoenix.Controller, formats: [:json]
      import Plug.Conn
      unquote(verified_routes())
    end
  end
  def channel do
    quote do
      use Phoenix.Channel
      unquote(verified_routes())
    end
  end
  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      unquote(verified_routes())
    end
  end
  defp verified_routes do
    quote do
      use Phoenix.VerifiedRoutes, endpoint: PulseOpsWeb.Endpoint, router: PulseOpsWeb.Router, statics: []
    end
  end
  defmacro __using__(which) when is_atom(which), do: apply(__MODULE__, which, [])
end
