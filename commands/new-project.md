---
description: Create a new prototype project from the platform templates
argument-hint: <app-name>
---
Create a new prototype named `$ARGUMENTS`. Run from `~/Developer`.

1. Create `prototypes/$ARGUMENTS/` with `docs/adr/` and run `git init`.
2. Copy `_platform/templates/PROJECT_CLAUDE.md` to `CLAUDE.md` and `_platform/templates/FUNCTIONAL_SPEC.md` to `docs/FUNCTIONAL_SPEC.md`; fill in the app name.
3. Add a `.gitignore` covering: node_modules, .venv, .env*, context/, *.parquet, *.duckdb, dumps.
4. Do not scaffold code yet. Tell me to write the spec, then run `/kickoff` inside the project.
