defmodule PulseOps.Repo.Migrations.CreateEvents do
  use Ecto.Migration
  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :workspace_id, :string, null: false
      add :service_id, :string, null: false
      add :environment, :string, null: false, default: "production"
      add :event_type, :string, null: false
      add :severity, :string, null: false, default: "info"
      add :message, :string, null: false
      add :payload, :map, null: false, default: %{}
      add :trace_id, :string
      add :occurred_at, :utc_datetime_usec, null: false
      add :received_at, :utc_datetime_usec, null: false
      add :idempotency_key, :string
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
    end
    create index(:events, [:workspace_id, :inserted_at, :id], name: :events_workspace_recent_index)
    create index(:events, [:workspace_id, :service_id, :inserted_at], name: :events_workspace_service_recent_index)
    create index(:events, [:workspace_id, :severity, :inserted_at], name: :events_workspace_severity_recent_index)
    create unique_index(:events, [:workspace_id, :idempotency_key], where: "idempotency_key IS NOT NULL", name: :events_workspace_id_idempotency_key_index)
  end
end
