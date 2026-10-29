# PulseOps — White Signal

PulseOps is a white-first operations analytics dashboard starter using Next.js App Router, TypeScript, Apache ECharts-style SVG visualization, Elixir/Phoenix, Ecto, PostgreSQL, and Phoenix PubSub/Channels.

## What's in this repository now

- A responsive White Signal dashboard shell with KPI summaries, a traffic chart, service-health table, incident cards, event search/severity filtering, and CSV export.
- Explicit demo labeling so illustrative values are not presented as production telemetry.
- A Next.js frontend package with strict TypeScript configuration and basic security headers.
- A Phoenix API project with a health endpoint, PostgreSQL event schema/migration, validated event ingestion, demo-only event listing, and a demo-only Phoenix channel.
- Docker Compose for local PostgreSQL, environment placeholders, and starter architecture/security/deployment documentation.

## Important implementation status

This is an **early MVP foundation, not the complete production specification**. The current GitHub version focuses on the overview and the first event-ingestion slice. The other navigation items currently change the selected section label; they are not separate, complete product routes yet.

The dashboard currently uses illustrative local sample data. It does not yet fetch its KPIs/events from the Phoenix API or subscribe to the WebSocket channel. The demo acknowledgement is local UI state.

Not implemented yet: production authentication, user/workspace membership, backend role enforcement, tenant-specific API-key lifecycle, complete analytics/events/services/endpoints/incidents/alerts/reports/settings workflows, frontend-to-backend query integration, replay/cursor recovery, production notification delivery, full OpenAPI generation, and production deployment verification.

Do not connect this starter to sensitive or production telemetry until the missing authentication, authorization, and isolation controls are implemented and tested.

## Stack

- **Frontend:** Next.js App Router, React, TypeScript, Tailwind CSS v4 baseline, Lucide React.
- **Backend:** Elixir, Phoenix, Ecto SQL, PostgreSQL, Phoenix PubSub/Channels, Bandit, Jason.
- **Deployment target:** Vercel for the frontend; an Elixir-compatible container runtime for Phoenix; managed PostgreSQL.

## Local setup

Prerequisites: Node.js 20.9+, Corepack/pnpm, Elixir/Erlang/OTP compatible with the selected Phoenix version, and Docker for PostgreSQL.

```bash
corepack pnpm install
docker compose up -d postgres

# Terminal 1 — API
cd apps/api
mix deps.get
mix ecto.create
mix ecto.migrate
PULSEOPS_DEMO_MODE=true mix run priv/repo/seeds.exs
PULSEOPS_DEMO_MODE=true mix phx.server

# Terminal 2 — frontend, from repository root
corepack pnpm --filter @pulseops/web dev
```

Open `http://localhost:3000`. API health: `http://localhost:4000/health`.

The ingestion endpoint requires a server-side `PULSEOPS_INGEST_KEY` of at least 32 characters. In demo mode, writes are restricted to the synthetic `demo` workspace. Configure environment variables in your local shell; never commit real secrets.

## Deployment notes

Vercel should build the Next.js app from the monorepo with workspace dependencies available. Phoenix must be deployed separately to an Elixir-compatible runtime. Configure PostgreSQL TLS, a strong `SECRET_KEY_BASE`, strict CORS/WebSocket origin allowlists, HTTPS, backups, and migration procedures.

See `docs/` for current architecture, API, security, real-time, and deployment boundaries. This project has not yet had dependency installation, framework builds, automated tests, or production deployment verified in this environment.
