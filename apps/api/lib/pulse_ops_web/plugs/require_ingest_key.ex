defmodule PulseOpsWeb.Plugs.RequireIngestKey do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]
  def init(opts), do: opts
  def call(conn, _opts) do
    expected = System.get_env("PULSEOPS_INGEST_KEY")
    supplied = conn |> get_req_header("x-pulseops-ingest-key") |> List.first()
    cond do
      not is_binary(expected) or byte_size(expected) < 32 ->
        conn |> put_status(:service_unavailable) |> json(%{error: %{code: "ingestion_not_configured"}}) |> halt()
      is_binary(supplied) and byte_size(expected) == byte_size(supplied) and Plug.Crypto.secure_compare(expected, supplied) -> conn
      true -> conn |> put_status(:unauthorized) |> json(%{error: %{code: "invalid_ingestion_key"}}) |> halt()
    end
  end
end
