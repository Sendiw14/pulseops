defmodule PulseOpsWeb.Router do
  use PulseOpsWeb, :router
  pipeline :api do
    plug :accepts, ["json"]
  end
  pipeline :ingest do
    plug PulseOpsWeb.Plugs.RequireIngestKey
  end
  scope "/", PulseOpsWeb do
    pipe_through :api
    get "/health", HealthController, :show
    get "/api/v1/events", EventsController, :index
  end
  scope "/", PulseOpsWeb do
    pipe_through [:api, :ingest]
    post "/api/v1/events", EventsController, :create
  end
end
