defmodule PulseOps.Events.EventTest do
  use ExUnit.Case, async: true
  alias PulseOps.Events.Event
  test "accepts a valid event" do
    now = DateTime.utc_now() |> DateTime.truncate(:microsecond)
    attrs = %{workspace_id: "demo", service_id: "checkout-api", event_type: "request.completed", severity: "info", message: "Request completed", occurred_at: now, received_at: now, payload: %{}}
    assert Event.changeset(%Event{}, attrs).valid?
  end
  test "rejects unsupported severity" do
    now = DateTime.utc_now() |> DateTime.truncate(:microsecond)
    attrs = %{workspace_id: "demo", service_id: "checkout-api", event_type: "request.completed", severity: "mystery", message: "Bad event", occurred_at: now, received_at: now}
    refute Event.changeset(%Event{}, attrs).valid?
  end
  test "rejects oversized payloads" do
    now = DateTime.utc_now() |> DateTime.truncate(:microsecond)
    attrs = %{workspace_id: "demo", service_id: "checkout-api", event_type: "request.completed", severity: "info", message: "Big payload", occurred_at: now, received_at: now, payload: %{"blob" => String.duplicate("x", 33_000)}}
    refute Event.changeset(%Event{}, attrs).valid?
  end
end
