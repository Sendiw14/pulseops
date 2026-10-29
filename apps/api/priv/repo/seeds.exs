if System.get_env("PULSEOPS_DEMO_MODE", "false") != "true" do
  IO.puts("PULSEOPS_DEMO_MODE is not true; skipping synthetic telemetry seeds.")
else
  alias PulseOps.Events.Event
  alias PulseOps.Repo
  import Ecto.Query
  Repo.delete_all(from event in Event, where: event.workspace_id == "demo")
  now = DateTime.utc_now() |> DateTime.truncate(:microsecond)
  services = ["checkout-api", "edge-gateway", "identity-service", "catalog-api", "event-worker"]
  severities = ["info", "info", "success", "warning", "critical"]
  messages = ["Request completed successfully", "Request completed successfully", "Telemetry heartbeat received", "Upstream response exceeded latency target", "Request returned a server error"]
  for sequence <- 1..72 do
    index = rem(sequence, length(services))
    timestamp = DateTime.add(now, -(sequence * 47), :second)
    %Event{} |> Event.changeset(%{workspace_id: "demo", service_id: Enum.at(services, index), environment: if(rem(sequence, 11) == 0, do: "staging", else: "production"), event_type: "request.completed", severity: Enum.at(severities, index), message: Enum.at(messages, index), occurred_at: timestamp, received_at: DateTime.add(timestamp, 1, :second), idempotency_key: "seed-#{sequence}", trace_id: "tr_seed_#{sequence}", payload: %{"demo" => true, "sequence" => sequence, "duration_ms" => 35 + rem(sequence * 29, 420)}) |> Repo.insert!()
  end
  IO.puts("Seeded 72 synthetic events in the isolated demo workspace.")
end
