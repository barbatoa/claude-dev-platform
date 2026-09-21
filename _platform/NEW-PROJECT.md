# Starting a new project

The path from an idea to something running, and the habits that made it work. Written after
`content-digest` went through it end to end — the notes marked **learned** are things that cost
time the first time.

## 1. Create it

```sh
cd <workspace root>
# in Claude Code:
/new-project <app-name>
```

The folder decides the rules: `prototypes/` loads the prototype blueprint, `production/` loads the
production one. Moving the folder changes the tier — nothing inside the project needs editing.

You get `CLAUDE.md`, `docs/FUNCTIONAL_SPEC.md`, `docs/adr/`, a `.gitignore` and `git init`.
No code yet, deliberately.

**Do this before the first commit** — otherwise you rewrite history later, as I did:

```sh
git config user.email    # is it the identity you want published?
```

## 2. Write the spec yourself

This is the part not to delegate. Claude can format it; the decisions are yours.

Fill in `docs/FUNCTIONAL_SPEC.md`: what it must do, who reads the output, and — most valuable —
what is **out of scope**. Number every requirement (`FR-`, `CFG-`, `AC-`, `OQ-`, `OOS-`).

**learned:** those IDs become the project's backbone. Commits cite them, tests are named after
them, and when a decision changes later you annotate the ID as superseded rather than deleting it,
so the history of the thinking survives. `OOS-` items are what stop scope creep six sessions in;
`OQ-` items are the questions you know you can't answer yet.

## 3. Kick off

```sh
cd prototypes/<app-name>
# in Claude Code:
/kickoff
```

Three phases, each stopping for you: clarify the ambiguities, write `docs/PLAN.md`, then scaffold
the skeleton. Answer the clarifying questions properly — that conversation is where the design
actually gets decided.

**learned:** if the blueprint doesn't fit the project, say so now. `content-digest` dropped four of
the five prototype core items — no web tier, no database, no cloud — and recorded why in
`docs/adr/0001-*.md`. Deviating on purpose and writing it down is fine. Bending the project to fit
the blueprint is not.

## 4. One feature per session

```sh
/feature <name or number>
/clear          # between every feature
```

Each feature is one session: read the plan section, build the minimum that meets the acceptance
criteria, tests and lint green, commit on a branch. `/clear` between them keeps context small and
the work focused.

**learned:** build a preview path early. `--dry-run` — the whole pipeline with the writes turned
off — was the single most useful thing in `content-digest`, both for development and for the first
real run.

## 5. Decisions become ADRs

Anything you'd have to re-explain in three months goes in `docs/adr/` — a dependency added, a
requirement dropped, a blueprint item skipped. Use `templates/ADR.md`. Number them in sequence,
state the consequences honestly including the bad ones, and say what would make you revisit.

**learned:** four ADRs in a small project was the right amount, not too many. The most useful one
recorded something *removed*.

## 6. Ship it

Before the repo becomes visible to anyone:

```sh
git ls-files | grep -Ei "\.env|credential|service-account"   # must be empty
git log --all --name-only --format="" | sort -u | grep -Ei "\.env|secret"
git log --format="%an <%ae>" | sort -u                       # one identity, the right one
```

Write a `README.md` for someone with no context: what it does, what it deliberately doesn't do, how
to run it, where the spec and ADRs are. Private repo unless there's a reason otherwise — anything
public may be cloned or indexed before you change your mind.

## What actually goes wrong

**Tests passing is not evidence it works.** In `content-digest` a spreadsheet formula passed review
and broke silently on the first real append; a transcript fetcher looked permanently broken and was
merely rate-limited. Both were found by running the real thing and reading the output. Budget time
for a first real run and treat its output as the real test.

**Assume the first output is wrong somewhere.** The first digest put a 77-second announcement clip
in the highest-visibility slot. The fix was one paragraph in a prompt — but only because the
rejected candidates were recorded somewhere I could inspect. Keep the rejects.
