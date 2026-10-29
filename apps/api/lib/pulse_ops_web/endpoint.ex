defmodule PulseOpsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pulse_ops
  socket "/socket", PulseOpsWeb.UserSocket, websocket: true, longpoll: false
  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]
  plug Plug.Parsers, parsers: [:urlencoded, :multipart, :json], pass: ["*/*"], json_decoder: Jason, length: 1_048_576
  plug Plug.MethodOverride
  plug Plug.Head
  plug PulseOpsWeb.Plugs.Cors
  plug PulseOpsWeb.Router
end
