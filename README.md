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

## Built with this

| Project | Tier | Blueprint | Repository |
|---|---|---|---|
| **content-digest** | prototype | `prototype-v1`, overridden by ADR-0001 | private |
| **family-organizer** | prototype | `prototype-v1`, overridden by ADR-0001–0004 | private |

Projects are private by default and become public only if I decide to expose one, so the
repository column is the honest state rather than a link that would fail to open. A project's
tier is the folder it lives in here — `prototypes/` or `production/` — and moving the folder
is what promotes it.

**content-digest** produces weekly curated lists of recent YouTube videos on a domain, scored
by an LLM and published to a Google Sheet. It went through this process end to end, and
`_platform/NEW-PROJECT.md` was written from what that cost the first time.

It is the example of the blueprint being *overridden* rather than followed: `prototype-v1`
specifies a React PWA on Cloud Run with a Postgres source of truth, and content-digest is a
local CLI, run by hand, with no web tier, no database and no cloud. That divergence is argued in
its `docs/adr/0001-local-scheduled-cli-not-cloud-pwa.md`. A blueprint you cannot depart from in
writing is a cage, not a default.

**family-organizer** is a household organiser for two people: one list a couple plans together
each week, and a private daily list neither of them can write to for the other. It is the
clearest example of the *process* rather than the stack — a functional spec, a release ladder,
a plan for its first release and fifteen ADRs, and not one line of code yet. Its first release
is a two-week paper pilot with no app at all, which can cancel the project for the price of a
spreadsheet.

It departs from the blueprint further than content-digest does, and in a different direction:
not a different shape of program, but less of the blueprint surviving. No Postgres, no FastAPI,
no analytics tier, no Firebase Auth — the source of truth is a Google Spreadsheet the
non-technical half of the household can edit by hand on her phone, read and written straight
from the browser. What survives is the PWA, the hosting and the principles. It also gave
something back: a release ladder (ADR-0014) where each feature ships alone, is used for a
fortnight, and faces a gate that may answer *stop*.

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
