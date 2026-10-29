defmodule PulseOpsWeb.EventsController do
  use PulseOpsWeb, :controller
  alias PulseOps.Events
  def index(conn, params) do
    workspace_id = Map.get(params, "workspace_id", "demo")
    demo? = System.get_env("PULSEOPS_DEMO_MODE", "false") == "true"
    if demo? and workspace_id == "demo" do
      limit = parse_limit(Map.get(params, "limit", "50"))
      events = Events.list_events(workspace_id, limit: limit)
      json(conn, %{data: Enum.map(events, &serialize_event/1), page: %{limit: limit}, mode: "demo"})
    else
      conn |> put_status(:unauthorized) |> json(%{error: %{code: "authentication_required", message: "Authenticated workspace reads are not configured in this starter."}})
    end
  end
  def create(conn, params) do
    workspace_id = Map.get(params, "workspace_id")
    allowed = if System.get_env("PULSEOPS_DEMO_MODE", "false") == "true", do: workspace_id == "demo", else: workspace_id in String.split(System.get_env("PULSEOPS_INGEST_WORKSPACES", ""), ",", trim: true)
    cond do
      not is_binary(workspace_id) or workspace_id == "" ->
        conn |> put_status(:unprocessable_entity) |> json(%{error: %{code: "workspace_required", message: "workspace_id is required."}})
      not allowed ->
        conn |> put_status(:forbidden) |> json(%{error: %{code: "workspace_not_allowed", message: "This ingestion credential cannot write to that workspace."}})
      true ->
        attrs = Map.take(params, ~w(workspace_id service_id environment event_type severity message payload trace_id occurred_at received_at idempotency_key))
        attrs = case get_req_header(conn, "idempotency-key") do [key | _] -> Map.put_new(attrs, "idempotency_key", key); _ -> attrs end
        case Events.ingest_event(attrs) do
          {:ok, event} -> conn |> put_status(:created) |> json(%{data: serialize_event(event), request_id: List.first(get_resp_header(conn, "x-request-id"))})
          {:error, changeset} -> conn |> put_status(:unprocessable_entity) |> json(%{error: %{code: "invalid_event", message: "The event did not pass validation.", fields: Ecto.Changeset.traverse_errors(changeset, fn {message, _opts} -> message end)}})
        end
    end
  end
  defp parse_limit(value) when is_integer(value), do: value |> max(1) |> min(200)
  defp parse_limit(value) when is_binary(value) do
    case Integer.parse(value) do {number, ""} -> number |> max(1) |> min(200); _ -> 50 end
  end
  defp parse_limit(_), do: 50
  defp serialize_event(event), do: %{id: event.id, workspace_id: event.workspace_id, service_id: event.service_id, environment: event.environment, type: event.event_type, severity: event.severity, message: event.message, payload: event.payload, trace_id: event.trace_id, occurred_at: DateTime.to_iso8601(event.occurred_at), received_at: DateTime.to_iso8601(event.received_at), inserted_at: DateTime.to_iso8601(event.inserted_at)}
end
