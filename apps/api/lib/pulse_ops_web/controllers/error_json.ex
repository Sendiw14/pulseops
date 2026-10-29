defmodule PulseOpsWeb.ErrorJSON do
  def render(template, assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template), request_id: Map.get(assigns, :request_id)}}
  end
end
