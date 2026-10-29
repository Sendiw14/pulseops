defmodule PulseOps.Repo do
  @moduledoc "PostgreSQL repository for PulseOps contexts."
  use Ecto.Repo, otp_app: :pulse_ops, adapter: Ecto.Adapters.Postgres
end
