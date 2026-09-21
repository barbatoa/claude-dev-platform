# _platform

Single source of truth for architecture, conventions, templates, and Claude Code commands
shared by every project in `~/Developer`. Keep this folder in its own git repo and tag versions.

## How it loads
Claude Code loads every `CLAUDE.md` from the working directory up to your home folder.
A project in `~/Developer/prototypes/<app>/` therefore automatically loads:
1. `~/Developer/CLAUDE.md` → imports `principles.md`
2. `~/Developer/prototypes/CLAUDE.md` → imports `prototype/CORE.md`
3. `<app>/CLAUDE.md` → project specifics only

Nothing is duplicated. Moving a project from `prototypes/` to `production/` switches its rules.
Run `/context` or `/memory` inside a project to confirm what is loaded.

## Token budget
Only `principles.md` and the tier `CORE.md` are always loaded — keep both short.
Everything in `prototype/reference/` is read on demand, only for enabled modules.

## One-time setup
```bash
# Slash commands available everywhere
mkdir -p ~/.claude/commands
ln -s ~/Developer/_platform/commands/*.md ~/.claude/commands/

# Keep noise out of Claude's context (merge into ~/.claude/settings.json)
cat ~/Developer/_platform/claude/settings.user.json
```

## Layout
```
_platform/
├── NEW-PROJECT.md         # read this first: idea → spec → kickoff → features → ship
├── principles.md          # always loaded: simplicity, readability, token economy
├── prototype/
│   ├── CORE.md            # always loaded for prototypes
│   └── reference/         # on demand: modules and guides
├── production/CORE.md     # to be defined
├── templates/             # project CLAUDE.md, functional spec, ADR
├── commands/              # /new-project, /kickoff, /feature
├── claude/                # user-level settings snippet
└── CHANGELOG.md
```
