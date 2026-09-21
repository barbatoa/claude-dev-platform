# Guide: deploy
## One-time setup checklist
1. GCP project + billing account + $1 budget alert.
2. Enable Cloud Run, Cloud Scheduler, Secret Manager, Cloud Storage, Artifact Registry.
3. Firebase: add the GCP project, enable Hosting and Auth (email or Google sign-in).
4. Neon: create project; store connection string in Secret Manager.
5. Service accounts: one for the API, one for jobs, least privilege.
6. GitHub: Workload Identity Federation for deploys (no JSON keys); enable secret push protection.

## CI (single workflow)
- Path filters: `web/**` → build + `firebase deploy --only hosting`; `backend/**` → test, build image, deploy Cloud Run service and jobs.
- Cache `uv` and npm dependencies.
- After backend changes, regenerate the OpenAPI client (`npm run gen:api`) and fail if it differs from the committed one.
