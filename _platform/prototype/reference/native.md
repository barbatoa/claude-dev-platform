# Guide: native (Capacitor)
- Wrap `web/` with Capacitor; React, DuckDB-WASM, and ECharts run unchanged in the WebView.
- Switch Firebase Auth and FCM to their Capacitor plugins; backend unchanged.
- Consider native SQLite for local data (iOS may evict PWA storage).
- Add native value (push, offline, share) to pass App Store review.
- Keep browser-only APIs (storage, push, install prompt) inside `web/src/lib/` so they are easy to swap.
