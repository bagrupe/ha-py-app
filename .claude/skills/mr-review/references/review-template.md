# Review: !<mr> / #<issue> <title>

Author: <author>. Reviewer: <reviewer>. <one line on where the scope comes from, e.g. "MR description is empty; scope comes from #n and its notes.">

## Problem

<2-4 sentences: what the ticket asks for, including decisions taken in comments (with dates).>

## Out of scope (do not flag)

- <struck-through requirement or comment decision> (<source, date>)

## Baseline on `main` (what the change has to deal with)

| Fact | Where |
| --- | --- |
| <fact relevant to the change> | `<path>:<line>` |

## Reviewer baseline (D1-Dn)

<one line: why the ticket leaves these open, e.g. dependency unresolved.> These are the reviewer's own answers to the open questions, written before reading the diff. They are not confirmed up front: the review compares each one against what the author decided and discusses the differences.

- **D1 <short name>.** <decision + one-line reason from the main facts>

## Baseline vs. author

<one line: date, `main...HEAD`, commit range, path abbreviations used below.>

| # | Baseline | Author's choice | Where | Match / discuss |
| --- | --- | --- | --- | --- |
| D1 | | | | Match / **Discuss.** <why> |

Not decisions, carried to scoring: <gaps noticed while reading the diff>.

## Scoring

<copy the scale table and the test rule from references/scoring.md>

## Expected changes

<one line: scored date and commit. "Comment" is the MR comment to leave (empty = none). "Where" is the diff anchor.>

| # | Item | Meets | Blocking if | Score | Comment | Where |
| --- | --- | --- | --- | --- | --- | --- |
| C1 | | | | | | |
| Cn | No collateral change | Existing flows behave as on `main`; shared-code refactors are behaviour-preserving | An existing flow changes behaviour as a side effect | | | |

## Expected tests

Coverage: **Full** / **Partial** / **None**. Comments are suggestions, not blockers, except a weakened existing test and a red suite.

| # | Item | Covers | Coverage | Comment | Where |
| --- | --- | --- | --- | --- | --- |
| T1 | | C1 | | | |
| Tn | Suite green on a clean DB | all | | | |

## How to test

<omit when nothing observable changes. Setup beyond the running stack, then scenarios.>

Setup: <seed rows, config, users; point to skills>

| # | Scenario | Steps | Expected | Observe | Shows |
| --- | --- | --- | --- | --- | --- |
| S1 | Happy path | | | | C.. |
| S2 | <blocker repro> | | | | C.. |

## Acceptance criteria (#<issue>)

Status = lowest score among the mapped C items. Test coverage only lifts a criterion to Exceeds (via its C items), never lowers it.

| Criterion | Maps to | Status | Reason |
| --- | --- | --- | --- |
| <criterion as in the ticket> | C.., D.. | | |

## Verdict

<Mergeable / Not mergeable yet. Code blockers: C... Decisions to settle with the author: D... Tests: suite n/n on a clean DB; coverage gaps are suggestions.>
