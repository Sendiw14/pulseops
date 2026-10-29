# PulseOps — White Signal

A white-first operations analytics workspace built with Next.js App Router, TypeScript, Apache ECharts, Elixir/Phoenix, Ecto, PostgreSQL, and Phoenix PubSub/Channels.

> **Implementation status:** this repository is an MVP foundation, not the full production acceptance gate. The frontend includes an interactive dashboard and navigable feature routes backed by local demo fixtures. The Phoenix API includes persisted event ingestion, bounded payload validation, demo seeding, health checks, and a workspace-restricted demo channel. Production authentication, full tenant authorization, persisted secondary workflows, integrated frontend API queries, cursor replay, and deployment verification remain to be completed before production use.

## Highlights

- Original **WHITE SIGNAL** visual system: white surfaces, pale blue-gray canvas, fine dividers, restrained blue selection, and responsive layouts.
- Collapsible workspace navigation, command palette, responsive dashboard, and accessible control labels.
- Interactive Apache ECharts time series, metric switching, compare-period toggle, and CSV exports.
- Service health filtering, event search and severity filtering, trace-ID copying, demo incident acknowledgement, and export workflows.
- Routed views for analytics, live activity, events, services, endpoints, incidents, alerts, reports, integrations, onboarding, and settings.
- Phoenix event context and PostgreSQL migration with tenant/service scoping fields, severity validation, payload size guard, idempotency uniqueness, recent-event indexes, PubSub broadcasts, and a demo-only Phoenix Channel.
- Health endpoints, CORS allowlist, request-size limit, ingestion-key check, Docker Compose PostgreSQL, and engineering docs.

## Current limitations

1. No production authentication exists. The login route is demo-only; displayed roles are not security controls.
2. Production read access is intentionally closed. Event listing is only exposed for the synthetic `demo` workspace while demo mode is enabled.
3. The ingestion key is a starter shared secret, not a tenant-specific API-key system.
4. The web dashboard presently uses local demo fixtures; it does not yet consume persisted PostgreSQL metrics/events through TanStack Query or subscribe to the Phoenix channel.
5. Most secondary page actions are local demo state and do not persist alert rules, incidents, reports, settings, users, or API credentials.
6. No lockfiles are included. Generate and commit pnpm and Mix lockfiles from a network-enabled developer environment before CI/release use.
7. No production deployment has been performed. Configure and verify hosting, secrets, domains, database, WebSocket origin, backups, migrations, and rollback settings.

The implementation deliberately avoids pretending these missing pieces are complete.

## Technology

- Web: Next.js App Router, React, TypeScript strict mode, Tailwind CSS v4, Lucide React, Motion, Apache ECharts, TanStack Query, React Hook Form/Zod, Sonner.
- API: Elixir, Phoenix, Ecto SQL, PostgreSQL, Phoenix PubSub/Channels, Bandit, Jason, Telemetry.
- Deployment target: Vercel for `apps/web`; Elixir-compatible container runtime for `apps/api`; managed PostgreSQL.

## Local setup

Prerequisites: Node.js 20.9+; Corepack/pnpm; Elixir and Erlang/OTP supported by Phoenix; Docker (recommended for PostgreSQL).

```bash
corepack pnpm install
cp apps/web/.env.example apps/web/.env.local
docker compose up -d postgres

# Terminal 1
cd apps/api
mix deps.get
mix ecto.create
mix ecto.migrate
PULSEOPS_DEMO_MODE=true mix run priv/repo/seeds.exs
PULSEOPS_DEMO_MODE=true mix phx.server

# Terminal 2, from repository root
corepack pnpm --filter @pulseops/web dev
```

Open `http://localhost:3000`. The API health route is `http://localhost:4000/health`.

Root commands include `make setup`, `make dev`, `make test`, `make check`, and `make build`; they require the toolchains above.

## Deployment

Set the Vercel project root to `apps/web` and ensure workspace dependency resolution uses the repository root. Deploy Phoenix separately on an Elixir-compatible runtime and configure PostgreSQL, secrets, HTTPS, CORS, and WebSocket origin allowlists. Do not expose secret variables through `NEXT_PUBLIC_*`.

See `docs/` for architecture, API contract, security, real-time protocol, testing, and deployment notes.
