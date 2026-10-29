import Config
config :pulse_ops, PulseOps.Repo,
  username: System.get_env("POSTGRES_USER", "pulseops"),
  password: System.get_env("POSTGRES_PASSWORD", "pulseops"),
  hostname: System.get_env("POSTGRES_HOST", "localhost"),
  database: System.get_env("POSTGRES_DB", "pulseops_dev"),
  port: String.to_integer(System.get_env("POSTGRES_PORT", "5432")),
  pool_size: 10
config :pulse_ops, PulseOpsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: String.to_integer(System.get_env("PORT", "4000"))],
  server: true
