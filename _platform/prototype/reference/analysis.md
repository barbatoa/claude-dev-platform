# Module: analysis
Claude Code analyzes data on a schedule and records decisions. Runs on the owner's Mac (launchd), using the Pro login.

- ETL also writes `context/`: `summary.md` (compact key metrics and changes), `previous_decisions.json`, `metadata.json`.
  Keep `summary.md` short — it is the main token cost of each run.
- `analysis/PROMPT.md`: goals, decision rules, output format.
- `analysis/run.sh`: download context → `claude -p` with PROMPT.md → validate against `decision.schema.json` → `POST /api/v1/decisions`.
- Decision fields: `id, created_at, type, summary, rationale, confidence, recommended_actions, data_window`.
- Claude proposes; high-impact actions need confirmation in the app.
- Prefer aggregated or de-identified data in `context/`.
