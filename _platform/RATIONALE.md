# Why the blueprint looks like this

Plain-language reasoning behind `prototype-v1`. Not loaded into Claude's context by any
`CLAUDE.md` — this is for humans. The blueprint says *what*; this says *why*.

## 0. The four constraints that decide everything

Almost every choice falls out of these, so read them first:

1. **1–2 users.** There is no scale problem. Anything that exists to handle load is waste.
2. **$0 beyond Claude Pro.** Every service must have a free tier that scales to zero.
3. **The author is one person working through an LLM agent.** Optimising for *Claude's*
   throughput matters as much as optimising for yours.
4. **The goal is to learn whether an idea works**, not to run a business on it.

Constraint 3 is the unusual one and explains the choices that look over-engineered.
A human developer holds a codebase in their head. An agent holds only what fits in its
context window, and it re-reads it every session. So the architecture is shaped to make
the code *cheap to load and hard to get wrong*, even when that costs a little ceremony.

## 1. Why a `_platform/` folder at all

Claude Code reads every `CLAUDE.md` from your working directory up to your home folder.
That's a free inheritance mechanism, so the platform uses it:

```
~/Developer/CLAUDE.md              → principles (all projects)
~/Developer/prototypes/CLAUDE.md   → prototype rules (all prototypes)
~/Developer/prototypes/app/CLAUDE.md → just this app
```

**Why:** write a rule once, every project gets it. Change a rule, every project changes.
The alternative — copying conventions into each project — guarantees they drift apart, and
you'd never know which copy was right.

**Why the tier is the folder:** a project's rigour level has to be stored *somewhere*
the agent always sees. A field inside a file can be ignored or forgotten; a folder path
cannot. `mv` becomes the promotion command.

## 2. Why the docs are so short

The always-loaded set (`principles.md` + tier `CORE.md`) is ~120 lines on purpose.
Everything in `reference/` loads only if a module is ticked in the project's `CLAUDE.md`.

**Why:** context is a budget, not a library. Every token of standing instruction is a token
not available for your actual code, *and* it is re-sent on every single request. Long
conventions documents also get skimmed — by models as well as people. Short and imperative
("Reads never go through the API") survives; a 3-page discussion of read strategies does not.

## 3. Frontend

| Choice | Reasoning |
|---|---|
| **TypeScript, strict** | The compiler is a second reviewer. An agent writing code you don't read line-by-line needs a machine that rejects its mistakes. Strict mode is where most of that value sits. |
| **React** | Not because it's best — because it's the framework with the most training data behind it. The agent writes idiomatic React with fewer corrections than anything niche. Boring is a feature. |
| **Vite** | Near-zero config, instant dev server. Config files are code you have to maintain and the agent has to read. |
| **Tailwind** | Styling lives next to the markup, so there's no second file to keep in sync and no "where is this class defined" search. Fewer files in context per change. |
| **PWA (`vite-plugin-pwa`)** | One codebase runs on phone and desktop, installs to a home screen, costs nothing, needs no App Store review. For validating an idea with 2 users, a native app is pure overhead. |

## 4. Analytics in the browser (the most unusual decision)

DuckDB-WASM reads Parquet files and runs SQL **inside the user's browser**. ECharts draws
the result.

**Why:** it moves all query compute off your infrastructure and onto the device, which is
how a real analytics app fits in a $0 budget. Parquet is columnar and compresses hard, so a
few MB can hold a lot of pre-aggregated history, and the PWA cache means repeat views need
no network at all.

**The rule that follows:** *reads never go through the API; the API only writes.* This keeps
the backend tiny — no query endpoints, no pagination, no filter parameters, no N+1 problems.

**What it costs — know this before you use it:** your data is only as fresh as the last ETL
run (daily by default), the WASM payload is heavy on mobile, and the moment you need a
genuinely live read (prefilling an edit form, "what did I just submit?") you are fighting the
rule. At 1–2 users a plain `GET` against Postgres would be simpler and instant. Treat this as
the blueprint's biggest open bet, not settled doctrine.

## 5. The generated API client

FastAPI publishes an OpenAPI schema; `openapi-typescript` turns it into TS types and
`openapi-fetch` calls it. No hand-written interfaces. CI regenerates and fails if the
committed client differs.

**Why:** this is the highest-value line in the whole blueprint. The frontend/backend contract
is exactly where an agent hallucinates — a field named `created` instead of `created_at`, a
number where a string goes. Generating the types makes that class of bug a compile error
instead of a runtime surprise, and the CI check stops the two sides silently diverging.

**General lesson:** wherever the same truth exists in two places, generate one from the other.

## 6. Backend

| Choice | Reasoning |
|---|---|
| **FastAPI** | Gives you the OpenAPI schema for free (see above), and request validation is declarative rather than hand-written. |
| **SQLModel** | One class is both the database table and the validation model. The usual split — ORM model + separate schema classes — means three files to change per field and three places to drift. One model is fewer moving parts. |
| **Python 3.12 + `uv`** | `uv` replaces pip, venv, and pip-tools with one fast tool, so the agent has one command to remember instead of four. |
| **One Dockerfile** | The API and the scheduled jobs are the *same image with different commands*. One build to maintain, one thing to deploy, no chance of the job running last week's code. |
| **ETL as numbered `.sql` files** | Transformation logic is shorter and clearer in SQL than in Python loops. Numbering makes order explicit, and each file diffs cleanly in review. |

## 7. Infrastructure

- **Neon Postgres** — real Postgres on a free tier that sleeps when idle. Postgres because
  it's the database the agent knows best and the one you'd keep if the idea succeeds.
- **Cloud Run, min 0 instances** — scales to zero, so an idle prototype costs nothing.
  Max 2 instances so a bug can't generate a bill.
- **Firebase Hosting + Auth** — hosting rewrites `/api/**` to Cloud Run, which means the
  frontend and API share an origin and CORS never comes up. Auth is delegated because
  hand-rolled authentication is the one thing a solo prototype should never write.
- **Secret Manager + Workload Identity Federation** — no long-lived JSON key exists anywhere,
  so there is no key to accidentally commit. Cheap to set up once; prevents the worst mistake.
- **Cloud Scheduler, not GitHub cron** — scheduling belongs next to the thing it runs, and
  GitHub's scheduled workflows are unreliable and can quietly burn minutes.

## 8. Correctness rules, and the failure each one prevents

- **Client-generated UUIDs on writes** → the client owns the ID, so the server can upsert and
  a retry is harmless. This is what makes offline sync and flaky-network retries safe without
  any distributed-systems machinery.
- **Every endpoint requires auth; health check is the only exception** → no endpoint is
  accidentally public, because there is no "add auth later" step.
- **UTC ISO 8601 everywhere** → timezone bugs are silent, appear weeks later, and corrupt
  aggregates. One format, converted only at display time.
- **Parquet stays a few MB** → forces you to aggregate to the granularity the charts actually
  need, instead of shipping raw rows to the browser.
- **Synthetic seed data only** → real data in a repo is unrecoverable once pushed.

## 9. The workflow (`/new-project` → spec → `/kickoff` → `/feature` → `/clear`)

This is a context-management strategy more than a process.

- **Spec before code.** Ambiguity resolved in prose costs a paragraph; resolved in code it
  costs a rewrite. The spec is also the only document that says what "done" means.
- **`docs/PLAN.md` is the agent's durable memory.** Each feature lists its acceptance criteria
  and the files it touches, so a fresh session can start on feature 7 by reading one section
  instead of the whole repo.
- **One feature per session, then `/clear`.** A long session accumulates dead context — files
  that mattered an hour ago — which crowds out and degrades the current work. Clearing is
  cheap because the plan holds the state.
- **`/kickoff` stops twice for approval.** The two most expensive mistakes to discover late are
  a misunderstood spec and a wrong data model, so both get a human checkpoint.
- **Stable requirement IDs (`FR-`, `AC-`)** → a commit, a test, and a spec line can point at
  each other unambiguously months later.

## 10. Optional modules

`offline`, `push`, `integrations`, `analysis` are off by default and create **no files**
until enabled, and their reference docs aren't read unless ticked.

**Why:** unused code is worse than absent code — it must be read, maintained, and reasoned
about, and an agent will happily extend an abstraction you never wanted. Default-off is the
mechanism that keeps "build only what the spec requires" from being a slogan.

## 11. ADRs and version stamping

Each project records `Blueprint version at start: prototype-v1`, and deviations become an ADR
in `docs/adr/`.

**Why:** the blueprint is expected to be wrong in places. Stamping the version means an old
project isn't silently judged by new rules, and an ADR turns "this project is weird" into
"this project decided X for reason Y" — the difference between a documented exception and rot.
`content-digest`'s ADR-0001 is the working example: it discards most of the stack on purpose.

## 12. What to keep an eye on

- **The blueprint is still a hypothesis.** It was written before any project used it, and the
  first real project ([content-digest](../prototypes/content-digest)) opted out of most of it.
- **"Prototype" currently means both a rigour level and a specific stack.** A project that is
  clearly a prototype but a different shape (a scheduled CLI, say) has to argue its way out.
  Splitting *tier* (how much rigour) from *archetype* (which stack) would fix that.
- **`production/` is undefined**, so the promotion story isn't real yet.
- **The rules are advisory.** Nothing enforces "files under 200 lines" or "tests pass" — those
  become facts only when a hook, a pre-commit config, or CI checks them.
