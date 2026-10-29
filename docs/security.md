# Security

This is a development MVP, not a production-secure multi-tenant product. Do not connect it to sensitive or production telemetry.

- The demo dashboard data is illustrative and must not be interpreted as actual service health.
- The ingestion endpoint requires a server-only shared key of at least 32 characters.
- The shared key is not a substitute for tenant-specific scoped API credentials.
- Authenticated workspace reads, production WebSocket subscriptions, user sessions, and role enforcement are not implemented.
- Configure HTTPS, secrets, database TLS, strict origin allowlists, request limits, backups, and rotation before deployment.
- Never commit real environment files or expose private keys through `NEXT_PUBLIC_*`.
