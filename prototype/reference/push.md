# Module: push
- Firebase Cloud Messaging for web; the same backend works with Capacitor later.
- `vite-plugin-pwa` in `injectManifest` mode; push handler in `web/src/sw.ts`.
- Store device tokens in a `push_tokens` table; send from `backend/app/push.py`.
- iOS requires the app installed to the home screen (iOS 16.4+): include an install prompt.
- Payloads are generic ("You have an update"); details load in the app.
