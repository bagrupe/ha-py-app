# Scoring

## Scale (change items, C)

| Score | Meaning | Consequence |
| --- | --- | --- |
| **Blocking** | Missing, wrong, or breaks something else | Must change before merge |
| **Partial** | Main case works, specific gap remains | Fix in MR or agreed follow-up ticket |
| **Meets** | Reaches the `Meets` bar | Merge-ready |
| **Exceeds** | Meets **and** its behaviour is fully covered by tests (every mapped T row is Full) | Note only |

The scale is tied to what happens to the merge, not to quality adjectives ("good enough" says nothing about whether it can merge).

## Bars

- Each C item gets only two bars: `Meets` (the minimum requirement) and `Blocking if` (concrete failure). Partial sits between them; Exceeds is the test rule above.
- Bars come from the ticket and `main`. Write them before reading the diff. A bar changed afterwards is marked `(revised after diff: <reason>)`; the user reads scores against the bars in the finished file.
- Where an item depends on a D-decision still under discussion, the bar says "per agreed Dx" instead of fixing the answer. Score such items "**Blocking until Dx is agreed**" only if the author's choice contradicts an explicit ticket requirement; otherwise score the mechanics and write "(pending Dx)".
- Reuse of existing code, configurable limits (no literal needing a redeploy), typed errors, and following the existing pattern are **Meets**-level conventions, never Exceeds.
- `Blocking if` names an observable failure ("device still receives pushes for the deleted account"), not a missing implementation detail.

## Score cell

`**Score.** one-line reason` plus file:line in the Where column. Every Blocking score must have been verified in code on the branch.

## Tests (T)

- Rated **Full / Partial / None**, not on the C scale.
- Tests are not a requirement unless the ticket or a team convention says so (kommunal-app: neither). Missing tests or assertions are **suggestions** and never block.
- Two exceptions that are Blocking: the suite is red on a clean DB; an existing test was weakened or edited to pass.
- Read what each test actually asserts: result never checked, field never selected in the GraphQL query, the production path bypassed (e.g. setting a property instead of calling the mutation) all make it Partial.

## Acceptance criteria

- Status = lowest score among the mapped C items. Tests never lower an AC; they only lift it to Exceeds through its C items.
- Reason column names the C items that set the status and any pending D.

## Verdict

"Mergeable" or "Not mergeable yet", then: code blockers (C ids), decisions to settle with the author (D ids a C item waits on), suite result (n/n on a clean DB). Test gaps are listed as suggestions, if at all.
