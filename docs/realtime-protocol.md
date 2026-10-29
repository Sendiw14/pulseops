# Real-time protocol

Phoenix socket endpoint: `/socket`. The only accepted channel is `events:demo`, and it can be joined only when `PULSEOPS_DEMO_MODE=true`. New persisted events are broadcast on the `events:demo` PubSub topic as `event.created` payloads.

This is a demonstration-only channel. It does not provide production user authentication, per-workspace tickets, replay cursors, sequence guarantees, or missed-event recovery. Do not open it to production telemetry until those controls are implemented.
