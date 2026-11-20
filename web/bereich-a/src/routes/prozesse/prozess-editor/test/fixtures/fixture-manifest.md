# Prozess-Editor serialization fixtures

Real `GetProzessById` GraphQL responses captured from the local stack, used as the input to
`prozessToFlow` and the round-trip keystone test (spec `199-prozess-editor-single-source-refactor.md` §5).

-   **Captured:** 2026-06-15 (first four), `statusaenderung-test` added 2026-06-15
-   **Source:** .NET GraphQL `http://localhost:5000/graphql`, query `GetProzessById` (fragment closure, client `@export` directive stripped)
-   **Auth:** backoffice JWT for kommune _Landkreis Hameln-Pyrmont_ (`5a1aefef-809f-403d-a14c-27051353c7d4`)
-   **Shape:** each file is the full response `{ "my": { "kommune": { "prozessById": <ProzessEditorProzess> } } }`
-   **DB cross-check:** counts below verified against `Schritte` / `Verbindungen` / `ZustaendigkeitRollen` in `hameln-postgres` → `db`

> Capture was done with a throwaway Node script (`graphql` fragment-closure resolver + `fetch`) run from inside `bereich-a`; the script and the bearer token were **not** committed.

## Fixtures

| File                                              | Prozess / Version                                                                    | Steps | Edges | Roles | Step-type histogram                                                                          |
| ------------------------------------------------- | ------------------------------------------------------------------------------------ | ----- | ----- | ----- | -------------------------------------------------------------------------------------------- |
| `fuehrerschein-verlaengern.graphql-response.json` | `Führerschein verlängern` `d41d5923-…` / `0f44d48f-…`                                | 14    | 18    | 0     | Formular 11 · Bezahlen 1 · WarteAufBezahlungAbgeschlossen 1 · Ende 1                         |
| `maengelmelder.graphql-response.json`             | `Mängelmelder` `59cd9327-…` / `019e820f-…`                                           | 127   | 605   | 1     | Programmatisch 71 · Formular 54 · Ende 2                                                     |
| `bildung-teilhabe.graphql-response.json`          | `Bildungs- und Teilhabeleistungen Erstantrag` `78965ab6-…` / `019d85b9-…`            | 12    | 13    | 0     | Formular 10 · GovManagerRestExport 1 · Ende 1                                                |
| `bildung-teilhabe-variant.graphql-response.json`  | `Bildung- und Teilhabeleistungen Erstantrag (Version 2)` `01972041-…` / `019d676b-…` | 10    | 9     | 0     | Formular 8 · GovManagerRestExport 1 · Ende 1                                                 |
| `statusaenderung-test.graphql-response.json`      | `felix statusänderung test` `019e88ab-…` / `019ecb63-…`                              | 5     | 4     | 0     | Formular 1 · GovManagerRestExport 1 · WarteAufGovManager 1 · EmailForwarderExport 1 · Ende 1 |

`versionId` is whatever `latestVersion` resolved to at capture time, not necessarily the version listed during fixture selection.

## Step-type coverage

Real data now covers **8 of 8** supported `__typename`s:

-   ✅ `FormularSchritt`, `BezahlenSchritt`, `WarteAufBezahlungAbgeschlossenSchritt`, `EndeSchritt`, `ProgrammatischerSchritt`, `GovManagerRestExportSchritt` (first four fixtures)
-   ✅ `WarteAufGovManagerSchritt`, `EmailForwarderExportSchritt` — covered by `statusaenderung-test`, a hand-built process (`Formular → GovManagerRestExport → WarteAufGovManager → EmailForwarder → Ende`) authored to exercise the two types that have no other production instances.

→ The round-trip contract test runs over all five fixtures, so every supported step type is round-trip-validated against real data. No synthetic step fixtures are needed.

## Notes / redactions

-   No redactions applied. These are internal seed/staging processes; `sollZustaendigkeit` may reference mitarbeiter-gruppe ids/emails as they exist in the seed DB.
-   `statusaenderung-test` is a freshly authored process: its start `FormularSchritt` has `nodePosition: null` (never dragged) and its `GovManagerRestExport` step has empty `exportParts` / `vorgangsTyp`. Both are valid editor states and intentional coverage; its `WarteAufGovManager.govManagerSchrittId` is already populated.
-   `GhostSchritt` never appears (editor-only construct, not in the `Schritt` union) — ghost behavior is covered by synthetic graph-op fixtures, not here.
-   To re-capture, re-run an authenticated `GetProzessById` for the prozess ids above and overwrite the files; keep the histogram in `fixtures.smoke.test.ts` in sync.
