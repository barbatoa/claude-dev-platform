# Prototype Blueprint (prototype-v1)

**Goal:** validate an idea fast. 1–2 users. $0 beyond Claude Pro. Mobile-first analytics PWA.
Heavy computation runs in the browser; backend handles writes, integrations, and ETL.

## Stack
| Layer | Choice |
|---|---|
| Frontend | TypeScript (strict), React, Vite, `vite-plugin-pwa`, Tailwind |
| Analytics | DuckDB-WASM over Parquet (lazy-loaded), ECharts |
| API client | `openapi-typescript` + `openapi-fetch`, generated from FastAPI — no hand-written types |
| Backend | Python 3.12, `uv`, FastAPI, SQLModel (one model = DB + validation), Alembic |
| ETL | DuckDB SQL files: read Postgres → write Parquet |
| Hosting | Firebase Hosting (`/api/**` → Cloud Run), Cloud Run (min 0), Cloud Scheduler |
| Data | Neon Postgres (free) = source of truth; Cloud Storage = Parquet aggregates |
| Auth | Firebase Auth; FastAPI verifies ID token |
| Secrets | Secret Manager |
| CI/CD | GitHub Free, one Actions workflow with path filters |

## Repo layout
```
<app>/
├── CLAUDE.md               # project specifics + enabled modules
├── docs/                   # FUNCTIONAL_SPEC.md, PLAN.md, adr/
├── web/src/
│   ├── features/<name>/    # one folder per spec feature
│   ├── lib/                # api.ts (generated client), duckdb.ts, chart.tsx, auth.ts
│   └── App.tsx
├── backend/
│   ├── app/                # main.py, auth.py, db.py, models.py, routes/<feature>.py
│   ├── etl/                # run.py + NN_<aggregate>.sql
│   ├── migrations/
│   ├── tests/
│   └── Dockerfile          # one image; API and jobs are different commands
├── seed/                   # synthetic data only
├── firebase.json
└── .github/workflows/deploy.yml
```

## Core (always built)
1. SQLModel models + migration + seed script.
2. Auth + write endpoints under `/api/v1`; client-generated UUIDs for idempotent writes.
3. PWA shell: installable, caches app and latest Parquet.
4. ETL job (scheduled daily unless spec says otherwise) → Parquet + `manifest.json`.
5. Analytics views: download Parquet per manifest, query with DuckDB-WASM, render with ECharts.

## Optional modules — read the reference only if enabled
| Module | Enable when spec needs | Reference |
|---|---|---|
| offline | data entry without connectivity | `reference/offline.md` |
| push | notifications | `reference/push.md` |
| integrations | B2B webhooks or API pulls | `reference/integrations.md` |
| analysis | Claude Code analysis/decision loop | `reference/analysis.md` |

## Guides — read only when doing the task
`reference/deploy.md` (setup + CI) · `reference/native.md` (Capacitor) ·
`reference/showcase.md` (sharing the repo) · `reference/apps-script.md` (migration)

## Rules
- Reads never go through the API: analytics come from Parquet. The API only writes.
- Aggregate to the granularity the charts need; Parquet files stay small (a few MB max).
- Every endpoint requires auth; health check at `/api/health`.
- Tests: pytest for endpoints and ETL SQL output. Frontend: tests only for non-trivial data logic.
- UTC ISO 8601 timestamps everywhere.

## Cost guardrails
- $1 budget alert on the GCP billing account.
- Cloud Run: min 0, max 2 instances, smallest size that works.
- No scheduled GitHub workflows; scheduling lives in Cloud Scheduler.
- Verify free-tier limits at project start.

## Security
- Secrets only in Secret Manager and GitHub Actions secrets. `.env*`, data, and Parquet are git-ignored.
- No sensitive data in logs or push payloads.
