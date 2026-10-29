# Architecture

PulseOps is a pnpm monorepo with a Next.js App Router frontend in `apps/web` and an Elixir/Phoenix service in `apps/api`. PostgreSQL stores accepted telemetry events. Phoenix is the backend source of truth; Vercel hosts only the frontend.

## Current implementation boundaries

- The initial overview uses explicitly labeled illustrative demo fixtures.
- Phoenix exposes a health endpoint and an ingestion endpoint protected by a server-side shared ingestion key.
- Demo reads and subscriptions are intentionally restricted until authenticated workspace membership is implemented.
- Production authentication, full workspace membership, persisted secondary product workflows, and browser-to-Phoenix integration are not implemented in this starter.

## Deployment shape

Deploy `apps/web` to Vercel using the monorepo root for dependency resolution. Deploy `apps/api` as a Phoenix release on an Elixir-compatible runtime. Use managed PostgreSQL, TLS, a strong `SECRET_KEY_BASE`, and an explicit frontend origin allowlist.
