defmodule PulseOps.Events.Event do
  @moduledoc "Persisted telemetry event. Payloads are bounded before ingestion."
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "events" do
    field :workspace_id, :string
    field :service_id, :string
    field :environment, :string, default: "production"
    field :event_type, :string
    field :severity, :string, default: "info"
    field :message, :string
    field :payload, :map, default: %{}
    field :trace_id, :string
    field :occurred_at, :utc_datetime_usec
    field :received_at, :utc_datetime_usec
    field :idempotency_key, :string
    timestamps(type: :utc_datetime_usec, updated_at: false)
  end
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:workspace_id, :service_id, :environment, :event_type, :severity, :message, :payload, :trace_id, :occurred_at, :received_at, :idempotency_key])
    |> validate_required([:workspace_id, :service_id, :event_type, :severity, :message, :occurred_at, :received_at])
    |> validate_length(:workspace_id, min: 1, max: 100)
    |> validate_length(:service_id, min: 1, max: 160)
    |> validate_length(:environment, min: 1, max: 40)
    |> validate_length(:event_type, min: 1, max: 100)
    |> validate_inclusion(:severity, ["critical", "warning", "info", "success"])
    |> validate_length(:message, min: 1, max: 500)
    |> validate_length(:trace_id, max: 200)
    |> validate_length(:idempotency_key, max: 200)
    |> validate_payload_size()
    |> unique_constraint([:workspace_id, :idempotency_key], name: :events_workspace_id_idempotency_key_index)
  end
  defp validate_payload_size(changeset) do
    payload = get_field(changeset, :payload, %{})
    try do
      if byte_size(Jason.encode!(payload)) > 32_768, do: add_error(changeset, :payload, "must be 32 KiB or smaller"), else: changeset
    rescue
      _ -> add_error(changeset, :payload, "must be JSON serializable")
    end
  end
end
