import Config
if config_env() == :prod do
  database_url = System.get_env("DATABASE_URL") || raise "DATABASE_URL is required in production"
  secret_key_base = System.get_env("SECRET_KEY_BASE") || raise "SECRET_KEY_BASE is required in production"
  app_origin = System.get_env("APP_ORIGIN") || raise "APP_ORIGIN is required in production"
  config :pulse_ops, PulseOps.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE", "10")),
    ssl: System.get_env("DATABASE_SSL", "true") == "true"
  config :pulse_ops, PulseOpsWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: String.to_integer(System.get_env("PORT", "4000"))],
    secret_key_base: secret_key_base, server: System.get_env("PHX_SERVER", "true") == "true",
    check_origin: [app_origin]
end
