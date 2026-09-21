# claude-dev-platform

One architecture, shared by every project I build with Claude Code.

Each project is its own git repository. What those projects have in common — engineering
principles, a tier blueprint, document templates, and the slash commands that drive the
workflow — lives here, once, and is **referenced rather than copied**.

This repository *is* the workspace root. Projects sit inside it in `prototypes/` and
`production/`, each with its own `.git`, and are ignored by this one.

## The idea

Claude Code loads every `CLAUDE.md` from the working directory up to your home folder.
That is a free inheritance mechanism, so the platform uses it as one:

| Loaded for a project in `prototypes/<app>/` | Contains |
|---|---|
| `CLAUDE.md` | workspace rule: the platform is the single source of truth |
| `_platform/principles.md` | simplicity, readability, token economy — all tiers |
| `prototypes/CLAUDE.md` | tier marker |
| `_platform/prototype/CORE.md` | the prototype blueprint: stack, layout, conventions |
| `prototypes/<app>/CLAUDE.md` | this project only |

Write a rule once and every project inherits it. Change it once and every project changes.

**A project's tier is the folder it lives in.** A rigour level stored in a file can be
ignored or forgotten; a folder path cannot. `mv` is the promotion command — nothing inside
the project is edited when it graduates from prototype to production.

Only `principles.md` and the tier `CORE.md` are always in context; everything in
`_platform/prototype/reference/` is read on demand, and only for modules a project has
ticked on. Context is a budget, not a library.

## Layout

```
.
├── CLAUDE.md              # workspace rule  → imports principles.md
├── bootstrap.sh           # set this up on a new machine
├── _platform/             # the single source of truth
│   ├── principles.md      # always loaded, all tiers
│   ├── RATIONALE.md       # why the blueprint looks like this (for humans)
│   ├── NEW-PROJECT.md     # idea → spec → kickoff → features → ship
│   ├── prototype/
│   │   ├── CORE.md        # always loaded for prototypes
│   │   └── reference/     # on demand: offline, push, integrations, analysis, deploy…
│   ├── production/CORE.md
│   ├── templates/         # project CLAUDE.md, functional spec, ADR
│   ├── commands/          # /new-project, /kickoff, /feature
│   └── claude/            # user-level Claude Code settings snippet
├── prototypes/            # tier rules tracked here; each project is its own repo
├── production/
└── archive/               # retired projects, no tier rules
```

## Setup on a new machine

```sh
git clone git@github.com:barbatoa/claude-dev-platform.git Developer
cd Developer
./bootstrap.sh
```

`bootstrap.sh` derives the workspace root from its own location, so the clone can live
anywhere — `~/Developer`, `~/code`, `/opt/work`. It creates the tier folders and registers
the slash commands with Claude Code. It is idempotent and never overwrites an existing file.

Then clone the projects you need into `prototypes/` or `production/`; this repo ignores
their contents, so their independent history stays independent.

## Working in it

```sh
/new-project <app-name>   # scaffold docs, git init — no code yet
/kickoff                  # clarify the spec, plan, scaffold the core
/feature                  # implement one feature from the plan
```

`_platform/NEW-PROJECT.md` is the full walkthrough, written after the first project went
through it end to end. Blueprint changes are versioned in `_platform/CHANGELOG.md`; each
project records the blueprint version it started on. Deviations from the blueprint are
recorded as ADRs in the project's `docs/adr/`.

## Why these choices

`_platform/RATIONALE.md` is the long-form reasoning — the constraints that decide
everything, and why decisions that look over-engineered for a two-user app are not, once
the reader you are optimising for is an LLM agent rather than a human who holds the
codebase in their head.

## Using this

The guidelines here are public to read and closed to change — see `CONTRIBUTING.md`. Each
project that follows them lives in its own repository and links back here, so a
collaborator on a project can always open the conventions it was built to.

Clone this repository on its own to reproduce the working environment without any
projects; clone a project on its own to work on just that project. The two are independent
by design.
