# LageHelfer

## Domain model

```
Kommune (tenant: KRL Weserbergland)
└── Untereinheit / OE (a Landkreis)
    ├── MitarbeiterGruppe (group of backoffice users, e.g. Einsatzleitung Hameln)
    ├── Gebiet (area, GeoJSON polygon)
    │     └── einsatzleitungen: MitarbeiterGruppe[]   (many-to-many, groups of the Gebiet's OE)
    └── Lage (incident in one OE)
          └── gebiete: LageGebiet[]   (a Gebiet's pass through the Lage)
```

- `Gebiet.geometry` is a GeoJSON `Polygon` / `MultiPolygon` serialized as a string: `JSON.parse` it.
- A Lage contains Gebiete of its own OE only; others return `GebietOfOtherUntereinheitError`.
- Error `message`s are German; branch on `__typename`.

Fixed ids (stable across reseeds):

| | id | Gebiete |
|---|---|---|
| Kommune KRL | `84a06067-dc9e-46d0-b60a-8258cf7c1ce7` | |
| OE Hameln-Pyrmont | `a8cdc167-1a25-5bae-8173-06cd95b26d2f` | 8 (Salzhemmendorf has no Einsatzleitung) |
| OE Holzminden | `c9f2d8c6-9b91-5a41-9bb6-e9cbde743797` | 7 |

## Lifecycle

`LageGebietStatus`: `INACTIVE → CALLED_OUT → READY → LIVE → ENDED → DONE`

- Also allowed: `CALLED_OUT → ENDED`, `READY → ENDED`.
- Re-adding an `ENDED` or `DONE` Gebiet with `addGebieteToLage` starts a new pass at `INACTIVE`. `Lage.gebiete` shows only the current pass of each Gebiet.
- Any other transition returns `InvalidLageGebietTransitionError`.
- Each step stores `<status>At` and `<status>ById` on the `LageGebiet` (`calledOutAt`, `liveById`, …).

`LageStatus`: `CREATED → ACTIVE`, automatically when the first Gebiet goes `LIVE`. `closeLage` ends every running Gebiet (`CALLED_OUT`/`READY`/`LIVE` → `ENDED`) and sets `CLOSED`; a closed Lage accepts no further changes. `updateLageWarningText` sets the notice the citizen app shows (`activeLagen.warningText`). No mutation sets `archivedAt`.

| Flow step | API call |
|---|---|
| Create Lage | `createLage` |
| Add region | `addGebieteToLage`, then `setLageGebietStatus(CALLED_OUT)` |
| Region reports readiness | `setLageGebietStatus(READY)` |
| Live for region | `setLageGebietStatus(LIVE)` |
| Remove region | `setLageGebietStatus(ENDED)`, later `DONE` |

## Operations

| Operation | Does |
|---|---|
| `gebiete(withoutEinsatzleitung: Boolean)` | Gebiete of the caller's Kommune; `true` = only those without Einsatzleitung |
| `lagen(status: LageStatus)` | Lagen, newest first |
| `lage(id: UUID!)` | One Lage, or `null` |
| `kommune(kommuneId: UUID!)` | OEs and their groups |
| `my` | Current user; `... on Mitarbeiter { gruppen { id name } }` |
| `createLage` | New Lage, optional first Gebiete (`gebietIds`) |
| `updateLage` | Replace `title` and `note` |
| `updateLageWarningText` | Set or clear the citizen notice |
| `closeLage` | End all running Gebiete and close the Lage |
| `setLageMeldeweg(lageId, offen)` | Leitstelle only: take reporting offline (`meldewegPausiertSeit` set; no new reports or confirmations, hidden from `activeLagen`) or back online. Gebiete stay `LIVE` |
| `addGebieteToLage` | Add Gebiete as `INACTIVE` |
| `setLageGebietStatus` | Move one Gebiet to the next status |
| `addGebietEinsatzleitung` / `removeGebietEinsatzleitung` | Link or unlink a MitarbeiterGruppe and a Gebiet |

## Reports (Meldungen) for Leitstelle and Einsatzleitung

A report is an `Ausfuehrung` of the process "Ereignis melden" with `lage` set. Admins and Superadmins act as Leitstelle and see every report of their Kommune; other users see the reports whose `istZustaendigkeit.mitarbeiterGruppeId` is one of their groups. All operations need the global `LageHelfer` permission.

Fields on `Ausfuehrung`: `meldungsnummer` (from 1000, shown as "E-1042"), `ereignisStatus`, `einheit`, `klaerungSeit`, `klaerungGrund`, `klaerungKommentar`, `verwerfenGrund`, `externeStelle`, `externKommentar`, `klasse` (`A`–`D`), `benoetigteAusruestung`, `moeglicherNotfall`, `notfallPruefung`, `anzahlBestaetigungen`, `bestaetigungen { createdAt fotos }`.

`klasse`, `benoetigteAusruestung` and `moeglicherNotfall` are set by keyword rules when the report comes in (`Features/Lage/MeldungEinschaetzung.cs`, no LLM). `Einheit.ausruestung` lists the equipment on board; without an explicit list it is the standard of the vehicle type in the name (HLF, LF, TLF, DLK, RW, MTW, GW-L, RL).

`EreignisStatus`: `EINGEGANGEN → ZUGEWIESEN → IN_BEARBEITUNG → ERLEDIGT`, plus `IN_KLAERUNG`, `VERWORFEN` and `EXTERN_UEBERGEBEN`.

| Operation | Does | Who |
|---|---|---|
| `lageMeldungen(lageId, offen)` | Reports of a Lage, oldest first; `offen: false` = closed ones | both |
| `einheiten(mitarbeiterGruppeId)` | Units of the Kommune or of one Einsatzleitung | both |
| `createEinheit(name, mitarbeiterGruppeId, ausruestung)` / `deleteEinheit` | Maintain units; deleting returns their open reports to the inbox | Leitstelle or the group itself |
| `meldungEinheitZuweisen(ausfuehrungId, einheitId)` | Assign to a unit of the responsible group; `null` = back to inbox | both |
| `meldungFortsetzen(ausfuehrungId, aktion)` | `HILFE_EINLEITEN` or `EINSATZ_ABSCHLIESSEN` (initiates help first if needed); walks the process edges, so the citizen status follows | both |
| `meldungAnLeitstelleAbgeben(ausfuehrungId, grund, kommentar)` | Hand over to the Leitstelle (`IN_KLAERUNG`); `grund` is an `AbgabeGrund`, comment required only for `SONSTIGES`; unit released | both |
| `meldungEinschaetzungSetzen(ausfuehrungId, klasse, benoetigteAusruestung)` | Correct the rule-based class and equipment; omitted values stay | both |
| `meldungUmverteilen(ausfuehrungId, mitarbeiterGruppeId)` | Give to another Einsatzleitung; clears unit, assignee and Klärung | Leitstelle |
| `meldungVerwerfen(ausfuehrungId, begruendung)` | Close without an operation (`VERWORFEN`), reason required | Leitstelle |
| `meldungExternUebergeben(ausfuehrungId, stelle, kommentar)` | Hand to `BAUHOF`, `THW` or `ELS` and close (`EXTERN_UEBERGEBEN`) | Leitstelle |
| `meldungNotfallPruefen(ausfuehrungId, ergebnis)` | Resolve `moeglicherNotfall`: `KEIN_NOTFALL` keeps the report open, `AN_ELS_UEBERGEBEN` closes it as handed to `ELS` | Leitstelle |
| `meldungBestaetigen(publicId, fotos)` | "+1 · Sehe ich auch", anonymous; `publicId` is `activeLagen.meldungen.id`; only while the Gebiet is `LIVE` and the Meldeweg is online; at most 3 photos | anyone |

Citizen side: `activeLagen.meldungen` has `id`, `kategorie`, `anzahlBestaetigungen`; `ausfuehrungCreateAnonym` and `ausfuehrungStatusAnonym` return `meldungsnummer`.

Units come from the optional `einheiten` list of a Bereich in `seed.json` (only for Bereiche with `einsatzleitung`).

## Recipes

Gebiete with Einsatzleitung and polygon:

```graphql
query Gebiete {
  gebiete { id name untereinheitId geometry einsatzleitungen { id name } }
}
```

OEs and their groups (`{ "kommuneId": "84a06067-dc9e-46d0-b60a-8258cf7c1ce7" }`):

```graphql
query Organisation($kommuneId: UUID!) {
  kommune(kommuneId: $kommuneId) {
    untereinheiten { id name mitarbeiterGruppen { id name } }
  }
}
```

Create a Lage:

```graphql
mutation CreateLage($input: CreateLageInput!) {
  createLage(input: $input) {
    lage { id title status gebiete { gebiet { id name } status } }
    errors { __typename ... on Error { message } }
  }
}
```

```json
{ "input": { "untereinheitId": "a8cdc167-1a25-5bae-8173-06cd95b26d2f", "title": "Hochwasser Weser", "note": "Pegel steigt", "gebietIds": ["GEBIET_ID"] } }
```

Move a Gebiet to the next status:

```graphql
mutation SetStatus($input: SetLageGebietStatusInput!) {
  setLageGebietStatus(input: $input) {
    lage { status gebiete { gebiet { name } status liveAt } }
    errors { __typename ... on Error { message } }
  }
}
```

```json
{ "input": { "lageId": "LAGE_ID", "gebietId": "GEBIET_ID", "status": "CALLED_OUT" } }
```

Add or re-add Gebiete (`{ "input": { "lageId": "LAGE_ID", "gebietIds": ["GEBIET_ID"] } }`):

```graphql
mutation AddGebiete($input: AddGebieteToLageInput!) {
  addGebieteToLage(input: $input) {
    lage { gebiete { gebiet { name } status } }
    errors { __typename ... on Error { message } }
  }
}
```

Running Lagen:

```graphql
query RunningLagen {
  lagen(status: ACTIVE) {
    id title
    gebiete { status liveAt gebiet { name einsatzleitungen { name } } }
  }
}
```

Assign an Einsatzleitung (`{ "input": { "gebietId": "GEBIET_ID", "mitarbeiterGruppeId": "GROUP_ID" } }`):

```graphql
query WithoutEinsatzleitung {
  gebiete(withoutEinsatzleitung: true) { id name untereinheitId }
}

mutation Assign($input: AddGebietEinsatzleitungInput!) {
  addGebietEinsatzleitung(input: $input) {
    gebiet { name einsatzleitungen { name } }
    errors { __typename ... on Error { message } }
  }
}
```

## Known issues

**Roles are not enforced per Gebiet for Lage transitions.** (The report mutations above do check Leitstelle vs. Einsatzleitung.) Every user with the LageHelfer permission can run every transition on every Gebiet, including Gebiete whose Einsatzleitung is another group. If the client separates roles (e.g. only a Gebiet's own Einsatzleitung reports `READY`), enforce it client-side by comparing the user's groups with `gebiet.einsatzleitungen`:

```graphql
query MyGroups {
  my { ... on Mitarbeiter { gruppen { id name } } }
}
```

**MapLibre GL 6 in a Vite app renders a blank map** with nothing logged: MapLibre loads its worker from next to its own module file and Vite moves that file. Set the worker URL once (as bereich-a does in `location-formular-feld.tsx`):

```ts
import * as maplibregl from 'maplibre-gl';
import maplibreWorkerUrl from 'maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url';

maplibregl.setWorkerUrl(maplibreWorkerUrl);
```

## Glossary

| API term | Meaning |
|---|---|
| Kommune | Tenant |
| Untereinheit / OE | Organisational unit (here: Landkreis) |
| Gebiet / Bereich | Area with a polygon |
| MitarbeiterGruppe / Abteilung | Group of backoffice users |
| Einsatzleitung | Group in charge of a Gebiet |
| Lage | Incident |
| LageGebiet | A Gebiet's pass through a Lage |
