defmodule PulseOpsWeb.EventsChannel do
  use PulseOpsWeb, :channel
  alias PulseOps.Events
  @impl true
  def join("events:demo", _payload, socket) do
    if System.get_env("PULSEOPS_DEMO_MODE", "false") == "true" do
      Phoenix.PubSub.subscribe(PulseOps.PubSub, Events.topic("demo"))
      {:ok, assign(socket, :workspace_id, "demo")}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
  def join(_topic, _payload, _socket), do: {:error, %{reason: "unauthorized"}}
  @impl true
  def handle_info({:event_created, event}, socket) do
    if event.workspace_id == socket.assigns.workspace_id, do: push(socket, "event.created", %{id: event.id, type: event.event_type, occurred_at: DateTime.to_iso8601(event.occurred_at), received_at: DateTime.to_iso8601(event.received_at), service_id: event.service_id, environment: event.environment, severity: event.severity, message: event.message, trace_id: event.trace_id, payload: event.payload})
    {:noreply, socket}
  end
end
