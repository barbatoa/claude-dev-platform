# {{APP_NAME}}
{{ONE_LINE_PURPOSE}}

Blueprint version at start: prototype-v1 — conventions live in [claude-dev-platform](https://github.com/barbatoa/claude-dev-platform), not in this repo.
Spec: `docs/FUNCTIONAL_SPEC.md` · Plan: `docs/PLAN.md` — read the plan section for the current feature, not the whole file.

## Enabled modules
- [ ] offline
- [ ] push
- [ ] integrations
- [ ] analysis

## Commands
- Web: `cd web && npm run dev`
- Backend: `cd backend && uv run fastapi dev app/main.py`
- Tests: `cd backend && uv run pytest`
- Seed: `uv run python seed/seed.py`

## Project-specific notes
<!-- Only what differs from the blueprint. Link ADRs. Keep short. -->
