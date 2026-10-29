defmodule PulseOpsWeb.HealthController do
  use PulseOpsWeb, :controller
  def show(conn, _params) do
    json(conn, %{status: "ok", service: "pulseops-api", demo_mode: System.get_env("PULSEOPS_DEMO_MODE", "false") == "true"})
  end
end
