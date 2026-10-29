import Config
config :pulse_ops, PulseOps.Repo,
  username: System.get_env("POSTGRES_USER", "pulseops"),
  password: System.get_env("POSTGRES_PASSWORD", "pulseops"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: System.get_env("POSTGRES_DB", "pulseops_test"),
  port: String.to_integer(System.get_env("POSTGRES_PORT", "5432")),
  pool: Ecto.Adapters.SQL.Sandbox
config :pulse_ops, PulseOpsWeb.Endpoint, server: false
config :logger, level: :warning
