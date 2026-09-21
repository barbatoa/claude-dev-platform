# Module: integrations
- One file per partner: `backend/app/integrations/<partner>.py`.
- Webhooks: `POST /api/v1/webhooks/<partner>`, no user auth; verify HMAC signature + timestamp tolerance.
- Store every payload raw in `raw_events` (JSONB) before normalizing, so mappings can be replayed.
- Pulls: Cloud Run Job + Cloud Scheduler; incremental cursor per source in `sync_state`; idempotent upserts.
- Credentials in Secret Manager. Tests use recorded fixture payloads, never live calls.
