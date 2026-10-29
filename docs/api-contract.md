# API contract (starter)

Base URL: Phoenix API origin. JSON responses use UTF-8.

## Health
`GET /health` returns `{ "status": "ok", "service": "pulseops-api", "demo_mode": true }`.

## Ingest event
`POST /api/v1/events` requires `Content-Type: application/json`, `x-pulseops-ingest-key` and optionally `idempotency-key`. Required fields: `workspace_id`, `service_id`, `event_type`, `severity`, `message`, `occurred_at`. Optional: `environment`, `payload`, `trace_id`, `received_at`.

The ingestion plug requires a server-side key with at least 32 characters. Demo mode only permits the synthetic `demo` workspace. Accepted events are persisted and broadcast to the matching internal PubSub topic.

## List events
`GET /api/v1/events?workspace_id=demo&limit=50` is available only when `PULSEOPS_DEMO_MODE=true`. Production authenticated reads are deliberately disabled until authentication and workspace authorization exist.

Errors use an `error.code` field. This initial contract is not a complete OpenAPI specification.
