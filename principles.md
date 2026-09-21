# Engineering Principles (all tiers)

## Simplicity
- Build only what the functional spec requires. No speculative features, options, or config.
- Enable optional modules only when the spec needs them; otherwise create no files for them.
- No abstraction until the third real use. No generic repository, service, or manager layers.
- Prefer the standard library and platform features. Every new dependency needs a one-line reason in an ADR.
- Delete dead code immediately.

## Readability
- Code is read by a human reviewer: optimize for understanding in one pass.
- Feature folders; files under ~200 lines; functions under ~40 lines.
- Descriptive names over comments. Comments explain *why*, never *what*.
- One module docstring per Python file; type hints everywhere; TypeScript strict.
- No clever one-liners, metaprogramming, or deep inheritance.
- SQL is preferred for data transformation when it is shorter than code.

## Token economy (Claude Code)
- Work from `docs/PLAN.md`; do not re-read the whole repo. Search, then open only needed files.
- Read `reference/` docs only for modules enabled in the project's `CLAUDE.md`.
- One feature per session; run `/clear` between features.
- Default to a single session. Use subagents for isolated research or review; agent teams only when explicitly requested.
- Keep chat output short: summarize changes, do not paste code already written to files.
- Generate code instead of hand-writing duplicates (e.g. API types from OpenAPI).

## Workflow
- Clarify ambiguities before coding. Plan, get approval, then implement.
- Small commits on feature branches; `main` stays deployable.
- Lint and tests pass before a task is reported done.
- Deviations from the tier blueprint are recorded as ADRs in `docs/adr/`.
- Never commit secrets or real data.
