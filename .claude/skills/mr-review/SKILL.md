---
name: mr-review
description: "Review a GitLab merge request in kommunal-app the way the user reviews: ticket checklist and own baseline decisions written from `main` BEFORE reading the diff, then compare the author's decisions, score each expected change against pre-written bars, rate test coverage, derive acceptance-criteria status and a verdict. Use when asked to review an MR or branch (\"review MR 339\", \"review this branch\", /mr-review <n>). Produces `.claude/reviews/<mr>.md`; never posts comments."
disable-model-invocation: true
allowed-tools: Bash(glab *), Bash(git *), Bash(task backend:reset-test-db*), Bash(docker *), Bash(cd * && CI=true dotnet test *), Bash(CI=true dotnet test *)
---

# MR review

The review is a file, `.claude/reviews/<mr>.md`, built in phases. Run proactively from phase 0 to the verdict without stopping. The bars are the reference the user reads the scores against in the finished file; they are not an approval gate.

Read before starting: `references/review-template.md` (file layout), `references/scoring.md` (scale and bars). Seed C-items from `references/codebase-checks.md`. Word every MR comment per `references/comment-style.md`. Write the How to test section per `references/smoke-testing.md`.

## Hard rules

- **Baseline before diff.** Phases 1-2 use `main` only: `git show main:<path>`, `git grep <pat> main -- <paths>`, `git ls-tree -r --name-only main`. Do not open `git diff` until phase 3. If the diff was already seen, say which bars it influenced.
- **D-items are the reviewer's yardstick.** Never ask the user to decide or confirm them, never mark one "needs a decision". Differences with the author become discussion points.
- **Bars are written before the diff is read** and come from the ticket and `main`. Any later change is marked `(revised after diff: <reason>)`.
- **Tests are required only when the ticket or a team convention says so.** In this repo neither does (`HasTesting` = manual QA per `.gitlab/issue_templates/user_story.md`). Missing tests never block; see `scoring.md`.
- **Verify every Blocking claim in code** (file:line on the branch) before it lands in the file. "Probably" is not a score.
- **Never post** to GitLab. The user owns the threads; the Comment column is a draft.

## Phase 0: context

```
glab mr view <mr>
glab mr view <mr> -F json        # source branch, linked issue
glab issue view <issue> --comments
glab issue view <dependency> --comments   # every "Abhängigkeit: #n"
```

Apply struck-through requirements and decisions from comments ("daily 15.9.: ... nicht Teil des Tickets"). Collect: problem, out-of-scope list, open questions (contradictions between requirements and notes, dependencies that are unresolved). Note who authored vs. who is assigned.

Create `.claude/reviews/<mr>.md` from the template with Problem + Out of scope, then continue with phase 1.

## Phase 1: baseline from `main`

Map every entity, path and convention the change has to touch, with file:line. For a non-trivial ticket delegate the sweep (keeps file dumps out of context):

- Agent `Explore`, model `sonnet`, effort `medium`. Prompt must say: `main` only via git show/grep, never the working tree; facts only with file:line; under ~120 lines. List the concrete questions (entities and their PII fields, FKs and OnDelete, soft-delete handling, auth paths, existing similar features to compare, error convention, existing test files).

Write the "Baseline on main" table, then continue with phase 2. Interrupt only if `main` contradicts the ticket so badly that D-items can't be written.

## Phase 2: pre-review

Write into the file:

1. **Reviewer baseline D1..Dn**: own answer to every open question from phase 0, one line each. Reason from the `main` facts (e.g. Restrict FKs make a hard delete impossible).
2. **Expected changes C1..n** with a `Meets` bar and a `Blocking if` condition each. Include a "no collateral change" row: existing flows behave as on `main`.
3. **Expected tests T1..n** (what coverage would make each C item Exceeds) plus the clean-DB suite run.
4. **AC table** mapping every acceptance criterion to C items and D items.

Bars are frozen from here. If reading the diff shows a bar is wrong, change it, mark it `(revised after diff: <reason>)`, and score against the revised bar. Continue with phase 3.

## Phase 3: baseline vs. author

Now read the diff once at design level:

```
git log --oneline main..HEAD
git diff --stat main...HEAD
git diff main...HEAD -- <source dirs>     # skip generated files and binaries
```

Fill the "Baseline vs. author" table: baseline, author's choice, where (file:line), Match / **Discuss**. Add author decisions the baseline did not anticipate as extra D rows. Record non-decision gaps found on the way as "carried to phase 4". D-items are never scored.

## Phase 4: scoring

Start the suite in the background first (it takes minutes):

```
docker exec hameln-postgres pg_isready     # if not running: task containers:up
task backend:reset-test-db && cd backend && CI=true dotnet test UnitTests
```

A failure on a dirty DB is not evidence; always reset first. Then score every C row (Score, Comment, Where) and rate every T row (Full / Partial / None, Comment, Where) per `scoring.md`. Read the test file in full; check that tests assert what their name claims (unchecked results, fields never selected, steps bypassed).

**Optional verifier.** When the diff is large (roughly >15 source files or >5 Blocking candidates), spawn one `general-purpose` agent per Blocking candidate in parallel, effort `high`, prompt: "Try to disprove: <claim> at <file:line> on branch <b>. Report CONFIRMED or REFUTED with evidence." Otherwise verify in the main session.

## Phase 5: How to test

When the change is observable, write the "How to test" section per `references/smoke-testing.md`: setup, then scenarios for the happy path, each hand-reproducible blocker, and each guard the ticket names, with expected result and how to observe it. Check every operation against the branch's exported schema.

## Phase 6: acceptance criteria + verdict

AC status = lowest score of its mapped C items (tests only lift to Exceeds via C). Verdict: mergeable or not, listing code blockers, decisions to settle with the author (D rows marked Discuss that a C item depends on), suite result. Test gaps are suggestions.

Finish with a short report: verdict, blockers, Discuss items for the author, file path.
