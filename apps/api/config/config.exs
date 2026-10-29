import Config
config :pulse_ops, ecto_repos: [PulseOps.Repo], generators: [timestamp_type: :utc_datetime_usec]
config :pulse_ops, PulseOps.Repo, migration_primary_key: [name: :id, type: :binary_id], migration_timestamps: [type: :utc_datetime_usec]
config :pulse_ops, PulseOpsWeb.Endpoint,
  url: [host: "localhost"], adapter: Bandit.PhoenixAdapter,
  render_errors: [formats: [json: PulseOpsWeb.ErrorJSON], layout: false],
  pubsub_server: PulseOps.PubSub, secret_key_base: String.duplicate("d", 64),
  server: false, check_origin: ["http://localhost:3000"]
config :phoenix, :json_library, Jason
config :logger, :console, format: "$time $metadata[$level] $message\n", metadata: [:request_id]
config :phoenix, :plug_init_mode, :runtime
import_config "#{config_env()}.exs"
