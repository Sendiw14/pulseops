defmodule PulseOpsWeb.Plugs.Cors do
  import Plug.Conn
  def init(opts), do: opts
  def call(conn, _opts) do
    allowed = System.get_env("APP_ORIGIN", "http://localhost:3000")
    origin = conn |> get_req_header("origin") |> List.first()
    conn = if origin == allowed do
      conn |> put_resp_header("access-control-allow-origin", origin) |> put_resp_header("vary", "origin") |> put_resp_header("access-control-allow-headers", "content-type,x-pulseops-ingest-key,idempotency-key") |> put_resp_header("access-control-allow-methods", "GET,POST,OPTIONS")
    else
      conn
    end
    if conn.method == "OPTIONS", do: conn |> send_resp(204, "") |> halt(), else: conn
  end
end
