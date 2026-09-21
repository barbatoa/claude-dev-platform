# Module: offline
- Writes go to an IndexedDB queue (`idb`, no heavier library) in `web/src/lib/queue.ts`, then sync.
- Sync on app open, on `visibilitychange`, and on `online`. iOS has no Background Sync.
- Each queued write carries a client UUID; the API upserts, so retries are safe.
- Analytics views merge pending local writes with Parquet results for freshness.
- Show a small "N pending" indicator; no complex conflict resolution (last write wins).
