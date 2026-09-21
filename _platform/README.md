# _platform

The single source of truth for architecture, conventions, templates, and Claude Code
commands shared by every project in this workspace. Never copy anything from here into a
project — reference it.

The workspace README (`../README.md`) covers how context loads, the tier model, and setup.
This file is the map of what lives in here.

| Path | Loaded | Purpose |
|---|---|---|
| `principles.md` | always, all tiers | simplicity, readability, token economy, workflow |
| `prototype/CORE.md` | always, in `prototypes/` | the prototype blueprint: stack and layout |
| `prototype/reference/*.md` | on demand | one file per optional module, read only when a project ticks it on |
| `production/CORE.md` | always, in `production/` | to be defined |
| `templates/` | never | project `CLAUDE.md`, functional spec, ADR |
| `commands/` | on invocation | `/new-project`, `/kickoff`, `/feature` |
| `claude/settings.user.json` | never | user-level settings snippet, applied by `bootstrap.sh` |
| `RATIONALE.md` | never | why the blueprint looks like this — for humans |
| `NEW-PROJECT.md` | never | the end-to-end walkthrough |
| `CHANGELOG.md` | never | one entry per blueprint version |

## Changing the blueprint

`principles.md` and each `CORE.md` are always in context and re-sent on every request, so
length there is a permanent tax — keep both short and imperative. Detail belongs in
`reference/`, which is read only when needed.

Every change to a blueprint gets a `CHANGELOG.md` entry under a version tag. Projects
record the version they started on in their own `CLAUDE.md`, so a project that has drifted
from the current blueprint is visible rather than silently stale.

Run `/context` inside a project to confirm exactly what is loaded.
