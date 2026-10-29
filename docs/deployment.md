# Deployment

## Frontend on Vercel
Create a Vercel project connected to this repository. Set the Root Directory to `apps/web`, allow the workspace root for package resolution, and use the Next.js framework preset. The frontend currently demonstrates local sample telemetry; setting a public API URL does not connect it to the Phoenix service yet.

## Phoenix API
Deploy `apps/api` on a runtime that supports Elixir/OTP releases and long-lived WebSocket connections. Configure `DATABASE_URL`, `DATABASE_SSL=true`, `SECRET_KEY_BASE`, `APP_ORIGIN`, `PORT`, and the ingestion key as secrets. Configure database migrations as a release step before switching traffic.

## PostgreSQL
Use a managed PostgreSQL instance with TLS, backups, restricted network access, and credentials separate by environment.

## Before production
Do not deploy as a production telemetry product until real authentication and authorization, tenant-scoped API keys, authenticated WebSocket tickets, full workspace isolation tests, retention policies, observability, migration rollback procedures, and frontend/backend integration are implemented and verified.
