defmodule PulseOpsWeb.UserSocket do
  use Phoenix.Socket
  channel "events:*", PulseOpsWeb.EventsChannel
  @impl true
  def connect(_params, socket, _connect_info) do
    if System.get_env("PULSEOPS_DEMO_MODE", "false") == "true", do: {:ok, socket}, else: :error
  end
  @impl true
  def id(_socket), do: nil
end
