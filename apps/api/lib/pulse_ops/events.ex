defmodule PulseOps.Events do
  @moduledoc "Event ingestion and tenant-scoped event queries."
  import Ecto.Query, warn: false
  alias PulseOps.Events.Event
  alias PulseOps.Repo
  @max_limit 200
  def ingest_event(attrs) when is_map(attrs) do
    now = DateTime.utc_now() |> DateTime.truncate(:microsecond)
    attrs = attrs |> stringify_known_keys() |> Map.put_new("received_at", now)
    %Event{} |> Event.changeset(attrs) |> Repo.insert() |> case do
      {:ok, event} = result ->
        Phoenix.PubSub.broadcast(PulseOps.PubSub, topic(event.workspace_id), {:event_created, event})
        result
      error -> error
    end
  end
  def list_events(workspace_id, opts \\ []) when is_binary(workspace_id) and byte_size(workspace_id) > 0 do
    limit = opts |> Keyword.get(:limit, 50) |> normalize_limit()
    Event |> where([event], event.workspace_id == ^workspace_id)
    |> order_by([event], desc: event.inserted_at, desc: event.id) |> limit(^limit) |> Repo.all()
  end
  def list_events(_, _), do: {:error, :workspace_required}
  def topic(workspace_id), do: "events:#{workspace_id}"
  defp normalize_limit(limit) when is_integer(limit), do: limit |> max(1) |> min(@max_limit)
  defp normalize_limit(_), do: 50
  defp stringify_known_keys(attrs) do
    allowed = ~w(workspace_id service_id environment event_type severity message payload trace_id occurred_at received_at idempotency_key)
    attrs |> Map.new(fn {key, value} -> {to_string(key), value} end) |> Map.take(allowed)
    |> Map.update("occurred_at", DateTime.utc_now() |> DateTime.truncate(:microsecond), &parse_datetime/1)
    |> Map.update("received_at", DateTime.utc_now() |> DateTime.truncate(:microsecond), &parse_datetime/1)
    |> Map.update("payload", %{}, fn value -> if is_map(value), do: value, else: %{} end)
  end
  defp parse_datetime(%DateTime{} = value), do: DateTime.truncate(value, :microsecond)
  defp parse_datetime(value) when is_binary(value) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, _offset} -> DateTime.truncate(datetime, :microsecond)
      _ -> value
    end
  end
  defp parse_datetime(value), do: value
end
