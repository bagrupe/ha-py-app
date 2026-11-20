# MR comment style

Comments in the Comment column are drafts the user posts under their own name.

- English, plain words. No filler openers ("Great work", "Just a thought"), no consultant vocabulary ("leverage", "robust", "holistic").
- State the failure first, then the fix: "The old token stays valid up to a day and `User()` doesn't check `IsDeleted`. With it you can still create an Antrag on the deleted Buerger. `User()` should refuse deleted users."
- One concrete scenario beats a general principle. Name the endpoint, field or flow that breaks.
- Blocking items: plain request ("should", "please drop"). Test gaps and nits: prefix "Suggestion:".
- D-item differences are questions to the author, not verdicts: "Requirement 2.5 says X; here Y. Which of the two was agreed?"
- Point at code with `file:line` or a symbol name; no line-by-line narration of the diff.
- No em dashes; use a period, colon or parentheses.
- Leave the cell empty when there is nothing to say. Do not praise in comments; Exceeds is visible in the score.
