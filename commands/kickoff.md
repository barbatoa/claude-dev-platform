---
description: Clarify the spec, plan, and scaffold the core of a project
---
Read `docs/FUNCTIONAL_SPEC.md`. The tier blueprint and principles are already in context.

**Phase 1 — Clarify.** List ambiguities, gaps, and conflicts with the blueprint. Propose which optional modules to enable. Stop and wait.

**Phase 2 — Plan.** Write `docs/PLAN.md`, concise:
- Data model (tables and fields)
- Endpoints (method, path, purpose)
- Parquet aggregates and the views using them
- Enabled modules and what each needs
- Ordered feature list; each feature with acceptance criteria and the files it touches
Update the enabled modules in `CLAUDE.md`. Stop and wait for approval.

**Phase 3 — Scaffold.** Build only the core skeleton: repo layout, models + migration + seed, auth, health endpoint, generated API client, PWA shell, one ETL SQL file, one analytics view, CI workflow. Read `reference/deploy.md` for CI. Commit on a branch. Reply with a short summary and the manual setup checklist.
