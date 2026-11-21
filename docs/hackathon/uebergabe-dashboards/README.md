# Übergabe: Frontend-Prototyp Backoffice „Leitstelle & Einsatzleitung“

Stand 22.11.2026. Quelle: Mock „DEICH – Dashboards & Meldeflow“ (Link im Team erfragen), Boards „Einsatzleitung Nord“ und „Leitstelle (Super-Admin)“. Beide sind im Mock klickbar. Deine Aufgabe sind diese beiden Ansichten. Die Bürger-Screens im selben Mock sind nur Kontext: Was die Leitstelle schaltet, sieht die Bürgerin dort (Button „Vorfall melden“, Meldung, Status).

PDF und Screenshots in `assets/` zeigen einen **älteren Stand** (u. a. noch mit Lage-Kachel und Drop-Zone „An Leitstelle abgeben“). Maßgeblich ist der Text unten.

## Kurzfassung

- Gebaut wird im bestehenden Backoffice **`web/bereich-a`** (React 19, Vite, Tailwind 3, react-router 7, urql + GraphQL-Codegen, MapLibre). Dort gibt es unter `/lage` schon eine schlichte Lage-Verwaltung, an die du andocken kannst.
- Zwei Ansichten, umschaltbar über „Ansicht“ oben rechts: **Einsatzleitung** (ein Zuständigkeitsgebiet, Ereignisse auf passende Einheiten verteilen) und **Leitstelle** (Gesamtlage, Meldeweg schalten, abgegebene Ereignisse klären).
- Die API deckt den Kern ab: Meldungen einer Lage mit Nummer, Status und +1-Zähler, Einheiten, Zuweisen, Klärung, Umverteilen, Verwerfen (Tabelle in Abschnitt 5).
- Noch nicht im Backend: Meldeweg pausieren, Grund der Abgabe, externe Übergabe (Bauhof/THW), Klasse, benötigte Ausrüstung, Ausrüstung der Einheiten, Notfall-Erkennung. Vorschlag in Abschnitt 5a; bis dahin im Frontend mit Werten aus Abschnitt 7.
- Farben und Schrift kommen aus dem Design System von bereich-a, nicht aus dem Mock (Abschnitt 6a).
- Ziel ist ein klickbarer Prototyp für die Demo, kein Produktivcode: Drag & Drop, Statuswechsel und Klärung müssen sich echt anfühlen.

---

## 1. Rollen und Ansichten

| Ansicht | Wer | Sieht | Demo-Login (lokal) |
|---|---|---|---|
| Einsatzleitung | Mitarbeitergruppe, die für ein oder mehrere Gebiete zuständig ist | nur Ereignisse und Einheiten des eigenen Zuständigkeitsgebiets | `einsatzleitung-hameln@example.com` |
| Leitstelle | Admin / Superadmin der KRL | alle Gebiete, alle Einsatzleitungen, Meldeweg-Steuerung | `admin-krl@example.com`, `superadmin-krl@example.com` |

Passwort: `demo.passwort` in `Dokumente/seed.json` (nicht ins Repo schreiben, das Repo ist öffentlich). Alle vier Demo-User haben das globale Recht `LageHelfer`.

Der Umschalter „Ansicht“ (*Leitstelle*, *Einsatzleitung Nord*, *Einsatzleitung Süd*) ist ein Demo-Hilfsmittel. Im Prototyp reicht: Vorauswahl aus der Rolle des eingeloggten Users, manuell umschaltbar. **Lage-Übergänge werden im Backend nicht pro Gebiet geprüft**, jeder mit `LageHelfer` darf alles. Trennung also clientseitig über `my { ... on Mitarbeiter { gruppen { id name } } }` gegen `gebiet.einsatzleitungen`.

---

## 2. Ansicht Einsatzleitung

**Kopfzeile (beide Ansichten):** Logo (im Mock „DEICH“, Name offen), Bereich „Einsatzleitung“ bzw. „Leitstelle“, Lage-Pill „● Aktiv · Lage Sturm“ (grün), Ansicht-Dropdown. Ist der Meldeweg pausiert: graue Pill „Inaktiv · Meldeweg geschlossen“.

**Titelzeile:** Name der Einsatzleitung + Liste der Gemeinden im Zuständigkeitsgebiet. Daneben eine kompakte Kennzahlen-Zeile: **5** neu · **3** zugewiesen · **2** in Bearbeitung · **11** erledigt.

**Spalte 1 – Eingang**
- Nur Ereignisse im Status *eingegangen*. Überschrift „Eingang · {Anzahl} Ereignisse“.
- Sortierung: Klasse (A vor B vor C vor D), dann +1-Anzahl absteigend, dann Wartezeit absteigend.
- Filter-Chips (`aria-pressed`): *Alle* · *Klasse A* · je Kategorie (*Sturm*, *Überschwemmung*) · *+1 ab 3*.
- Hinweis über der Liste: „Ereignis antippen oder ziehen: Passende Einheiten werden grün, unpassende rot.“
- Karte je Ereignis:
  - Zeile 1: Klassen-Badge (*A · dringend + wichtig*, *B · wichtig*, *C · dringend*, *D*), Kategorie-Badge, ID (`E-1042`), rechts +1-Zähler.
  - Titel, dann `Gemeinde · Ortsteil` und „wartet 2 h 10 min“ (über einem Schwellwert hervorgehoben, Vorschlag 2 h).
  - Chip „Braucht“ mit der benötigten Ausrüstung, z. B. „Motorkettensäge“ oder „Drehleiter, Absperrung“.
  - Button **An Leitstelle abgeben** öffnet ein Inline-Formular in der Karte: Dropdown *Warum können wir es nicht übernehmen?* (Benötigte Ausrüstung fehlt · Keine Einheit frei · Nicht unser Gebiet · Kein Fall für die Feuerwehr (z. B. Bauhof) · Sonstiges), Feld *Kommentar* (Platzhalter „z. B. Radlader nötig“), **An Leitstelle senden** / **Abbrechen**. Grund ist Pflicht, Kommentar nur bei *Sonstiges*. Danach Status *in Klärung*, das Ereignis erscheint in der Leitstelle unter „Klärung“.
- Karten sind **auswählbar** (Klick, blauer Rahmen) und **ziehbar** (Drag-Quelle). Auswahl und Ziehen lösen dieselbe Passt-Anzeige bei den Einheiten aus.

**Spalte 2 – Karte**
- OSM-Hintergrund, Ausschnitt auf das Zuständigkeitsgebiet (Polygone der Gebiete).
- Ein Marker je offenem Ereignis, Farbe = Kategorie, Zahl im Marker = +1-Anzahl, daneben die ID.
- Wünschenswert: Klick auf Marker wählt das Ereignis im Eingang aus und umgekehrt.

**Spalte 3 – Einheiten**
- Kopf: „Gezogen: **E-1042** · braucht Motorkettensäge“ für das ausgewählte Ereignis.
- Kachel je Einheit: Name (z. B. „HLF 20 Hameln“), „An Bord: Motorkettensäge, Pumpe, Absperrung“, Fahrzeugstatus „Status 2 · frei auf Wache“ / „Status 4 · am Einsatzort (aus ELS)“. Eine ELS-Anbindung gibt es nicht; Status 4, sobald der Einheit ein offenes Ereignis zugeordnet ist, sonst Status 2.
- Passt-Anzeige zum ausgewählten Ereignis: grüner Rahmen + Badge „✓ passt“, wenn die Einheit alles an Bord hat, sonst roter Rahmen + „✗ fehlt: Drehleiter“.
- Darin die zugeordneten Ereignisse mit ID, Kurztitel und Button **Erledigt**.
- Die ganze Kachel ist Drop-Ziel. Drop ⇒ Ereignis wird *zugewiesen*, verschwindet aus dem Eingang. Ob ein Drop auf eine rote Einheit blockiert oder nur warnt, ist offen (Abschnitt 9).

Offen: Wie wird aus *zugewiesen* ein *in Bearbeitung*? Die API bietet `meldungFortsetzen(HILFE_EINLEITEN)`; Vorschlag: Klick auf das Ereignis in der Einheit oder ein zweiter Button „Hilfe eingeleitet“.

---

## 3. Ansicht Leitstelle

**Kopfzeile:** wie oben, zusätzlich der Schalter für den Meldeweg:
- Aktiv: Pill „● Aktiv · Lage Sturm · seit 14:20“ + Button **Offline nehmen**.
- Pausiert: Pill „Inaktiv · Meldeweg geschlossen“ + Button **Online nehmen**.
- Offline heißt: keine neuen Meldungen, Button in der Bürger-App ausgeblendet, offene Ereignisse bleiben bearbeitbar. Der Schalter ist umkehrbar. Das endgültige Beenden der Lage (`closeLage`) bleibt in der Lage-Verwaltung unter `/lage`, nicht im Dashboard.

**Kennzahlen (eine Zeile):** **8** neu · **9** in Arbeit · **2** in Klärung (hervorgehoben, sobald > 0) · **17** erledigt | Nord: 5 neu · 2/4 Einheiten frei · Süd: 3 neu · 1/3 Einheiten frei | B-Team: 4 Plätze besetzt · ≈ 4–5 Notrufplätze entlastet (B-Team-Werte gemockt).

**Möglicher Notfall (rot, nur bei Treffern)**
- Titel „1 möglicher Notfall erkannt“; je Treffer ID, Gemeinde, Zitat aus der Beschreibung („Baum aufs Haus gefallen, Nachbarin noch drin“) und „Bürger wurde zur 112 geleitet“.
- Aktionen: **An ELS übergeben (EIDO)** (primär, rot) und **Geprüft, kein Notfall**. Beides nimmt den Treffer aus der Liste. Die EIDO-Übergabe ist für die Demo nur angedeutet (z. B. Toast „an ELS übergeben“).
- Gemeint sind Meldungen, bei denen die Vorfragen im Wizard verneint wurden, der Freitext aber nach Gefahr für Leib und Leben klingt.

**Klärung (links)**
- Alle abgegebenen Ereignisse, älteste zuerst. Überschrift „Klärung · 2 abgegebene Ereignisse“.
- Karte: Kategorie, ID, Gemeinde, „in Klärung seit …“ (lange Wartezeit hervorgehoben), Titel, Zeile „**Einsatzleitung Süd · Keine Einheit frei:** „Alle Pumpen im Einsatz““ (abgebende Einsatzleitung, Grund, Kommentar).
- Aktionen: Dropdown „Neu zuweisen an“ mit den anderen Einsatzleitungen (vorbelegt mit einer, die nicht abgegeben hat) **und externen Stellen** (*Bauhof*, *THW*) + **Zuweisen**; **Schließen mit Begründung** (Dialog, Pflichttext).
- Zuweisen an eine Einsatzleitung = Umverteilen, das Ereignis landet in deren Eingang. Zuweisen an eine externe Stelle = externe Übergabe, das Ereignis ist für DEICH abgeschlossen und geht ins Archiv.

**Gesamtlage (rechts):** Karte des ganzen Landkreises, Gebiete der Einsatzleitungen als eingefärbte Flächen mit Label, Marker wie bei der Einsatzleitung (ohne ID), Ereignisse in Klärung als orangefarbenes „!“.

**Alle Ereignisse (unten)**
- Tabelle: ID · Klasse · Kategorie · Ereignis · Gemeinde · Einsatzleitung · Status-Badge · +1 · Wartet · Aktionen.
- Filter-Tabs: *Offen* · je Einsatzleitung (*Nord*, *Süd*) · *Archiv* (erledigt, verworfen, extern übergeben).
- Aktionen je Zeile: **Umverteilen** (an andere Einsatzleitung oder externe Stelle), **Bearbeiten** (Kategorie, Titel, Ort, Klasse korrigieren), **Verwerfen** (rot, Bestätigung mit Begründung).

**NINA:** Im Dashboard gibt es dafür nichts mehr. Der Bürger-Screen „1a · Einstieg Warn-App (NINA)“ zeigt die Warnmeldung mit Link „Schaden melden“; Text und Versand verantwortet die Behörde über MoWaS, DEICH liefert nur Vorlage und Link.

---

## 4. Statusmodell eines Ereignisses

Das Backend liefert den Stand direkt als `Ausfuehrung.ereignisStatus` (`EreignisStatus`). Die Aktionen sind eigene Mutations; *kursiv* = noch nicht gebaut (Abschnitt 5a):

```
EINGEGANGEN ──meldungEinheitZuweisen──▶ ZUGEWIESEN ──meldungFortsetzen(HILFE_EINLEITEN)──▶ IN_BEARBEITUNG
     ▲   │                                   │                                                │
     │   │                                   └──────meldungFortsetzen(EINSATZ_ABSCHLIESSEN)───┴──▶ ERLEDIGT
     │   └──meldungAnLeitstelleAbgeben(grund, kommentar)──▶ IN_KLAERUNG
     │                                                          │
     └────────────meldungUmverteilen(gruppe)────────────────────┤   (Leitstelle, auch direkt aus der Tabelle)
                                                                ├──meldungVerwerfen(begruendung)──▶ VERWORFEN
                                                                └──meldungExternUebergeben(stelle)──▶ EXTERN_UEBERGEBEN
```

- `meldungEinheitZuweisen(einheitId: null)` legt die Meldung zurück in den Eingang.
- `meldungFortsetzen(EINSATZ_ABSCHLIESSEN)` geht bei Bedarf vorher automatisch „Hilfe einleiten“. Der Button „Erledigt“ funktioniert also auch bei *zugewiesen*.
- „Verwerfen“ (Tabelle) und „Schließen mit Begründung“ (Klärung) sind dieselbe Mutation `meldungVerwerfen`.
- *`grund` bei `meldungAnLeitstelleAbgeben` und `meldungExternUebergeben` / `EXTERN_UEBERGEBEN` gibt es noch nicht.* Heute nimmt die Mutation nur `kommentar` (Pflicht).
- Bürgerseite (`ausfuehrungStatusAnonym`, `MeldungStatus`): ZUGEWIESEN → `IN_BEARBEITUNG`, IN_BEARBEITUNG → `HILFE_UNTERWEGS`, ERLEDIGT und VERWORFEN → `ABGESCHLOSSEN`. Die Begründung sehen Bürger:innen nicht. Für EXTERN_UEBERGEBEN Vorschlag: ebenfalls `ABGESCHLOSSEN`.

---

## 5. Datenlage: was die API liefert

Endpunkte, Token und Rezepte: Skill `.agents/skills/graphql-api` (vor allem `references/lagehelfer.md`). Schema: `web/bereich-a/schema.graphql`.

| UI-Element | Quelle | Hinweis |
|---|---|---|
| Lage-Pill, Titel, „seit“ | ✅ `lagen(status: ACTIVE)` → `title`, `gebiete[].liveAt` | „seit“ = frühestes `liveAt` |
| Meldeweg offen (Pill aktiv) | ✅ abgeleitet | offen, solange mindestens ein `LageGebiet` `LIVE` ist |
| **Offline / Online nehmen** | ❌ | `closeLage` ist endgültig, `LIVE` kann nur nach `ENDED`. Siehe 5a |
| Gebiete, Polygone, Einsatzleitung je Gebiet | ✅ `gebiete { geometry einsatzleitungen { id name } }` | `geometry` ist ein GeoJSON-String → `JSON.parse` |
| Ereignisse einer Lage | ✅ `lageMeldungen(lageId, offen)` | Leitstelle (Admin/Superadmin) sieht alle, Einsatzleitung nur die ihrer Gruppen. `offen: false` = Archiv |
| Kurz-ID `E-1042` | ✅ `meldungsnummer` | Zahl ab 1000, Präfix „E-“ setzt das Frontend. Auch in `ausfuehrungCreateAnonym` und `ausfuehrungStatusAnonym` |
| Status-Badge | ✅ `ereignisStatus` | siehe Abschnitt 4 |
| Kategorie, Beschreibung, Fotos, Standort | ✅ `slotValues` (Slots `kategorie`, `beschreibung`, `bilder`, `adresse`) | unverschlüsselt (`PlainSlotValue`). Verschlüsselt sind nur `rueckrufnummer`, `prioritaet`, `interneNotiz`; Entschlüsseln wie in `components/ui/decrypt-value.tsx` |
| Gemeinde | ✅ `Ausfuehrung.lage.gebietName` | Ortsteil („Wohngebiet Nord“) gibt es nicht, ggf. aus Adresse |
| Einsatzleitung eines Ereignisses | ✅ `istZustaendigkeit.mitarbeiterGruppe` | |
| Wartezeit | ✅ `createdAt` | |
| +1-Zähler | ✅ `anzahlBestaetigungen`, Details in `bestaetigungen { createdAt fotos }` | Bürger-App: `activeLagen.meldungen { id kategorie anzahlBestaetigungen }` und `meldungBestaetigen(publicId, fotos)` |
| Einheiten | ✅ `einheiten(mitarbeiterGruppeId)`, `createEinheit`, `deleteEinheit`, `Ausfuehrung.einheit` | Status 2/4 aus den offenen Meldungen je Einheit ableiten. Demo-Einheiten über `einheiten` je Bereich in `seed.json` |
| Ereignis auf Einheit ziehen | ✅ `meldungEinheitZuweisen` | nur Einheiten der zuständigen Einsatzleitung |
| „Erledigt“ / in Bearbeitung | ✅ `meldungFortsetzen(aktion)` | geht die Prozess-Kanten, Bürger:innen sehen den neuen Stand |
| An Leitstelle abgeben, Klärung | ⚠️ `meldungAnLeitstelleAbgeben(kommentar)`, `klaerungSeit`, `klaerungKommentar` | **Grund fehlt**, Kommentar heute Pflicht. Siehe 5a |
| Neu zuweisen / Umverteilen an Einsatzleitung | ✅ `meldungUmverteilen(mitarbeiterGruppeId)` | nur Leitstelle |
| **Zuweisen an Bauhof / THW** | ❌ | siehe 5a |
| Verwerfen / Schließen mit Begründung | ✅ `meldungVerwerfen(begruendung)`, `verwerfenGrund` | nur Leitstelle |
| Lage endgültig beenden | ✅ `closeLage(lageId)` | nur in `/lage`, nicht im Dashboard |
| Hinweise für Bürger | ✅ `updateLageWarningText(lageId, warningText)` | erscheint in `activeLagen.warningText`; im Dashboard-Mock kein Button mehr, ggf. in `/lage` |
| **Klasse A–D** | ❌ | Es gibt nur den verschlüsselten Slot `prioritaet` (Hoch/Niedrig). Siehe 5a |
| **Braucht (Ausrüstung je Ereignis)** | ❌ | siehe 5a |
| **Ausrüstung der Einheiten, Passt-Anzeige** | ❌ | `Einheit` hat nur `name`. Abgleich im Client: benötigt ⊆ an Bord |
| **Möglicher Notfall, EIDO** | ❌ | Flag siehe 5a; EIDO nur andeuten |
| B-Team-Plätze, entlastete Notrufplätze | ❌ | mocken |
| Live-Aktualisierung | ⚠️ keine Subscriptions | Polling, z. B. alle 15 s mit `requestPolicy: 'network-only'` |

Alle Mutations liefern fachliche Fehler im Feld `errors` (z. B. `MeldungInKlaerungError`, `NotAllowedError`), immer `errors { __typename ... on Error { message } }` abfragen. Rollen: Admin und Superadmin gelten als Leitstelle, Nutzer mit Gruppe als deren Einsatzleitung. Alle brauchen das globale Recht `LageHelfer`.

**Empfehlung:** Echte API verwenden, wo sie existiert. Eine dünne Datenschicht (`useLageDashboard()` o. ä.) liefert die fehlenden Felder aus Abschnitt 7, bis 5a gebaut ist, und dient als Fallback, falls das Backend in der Demo nicht läuft.

### 5a. Backend-Erweiterung (entschieden 22.11., noch nicht gebaut)

Namen sind Vorschläge.

| Was | Vorschlag |
|---|---|
| Meldeweg pausieren | Neuer `LageGebietStatus.PAUSED` mit `LIVE → PAUSED`, `PAUSED → LIVE`, `PAUSED → ENDED`. Komfort-Mutation `setLageMeldeweg(lageId, offen: Boolean)` schaltet alle laufenden Gebiete der Lage. `AcceptsMeldungen` bleibt nur `LIVE`, `activeLagen` blendet pausierte Gebiete aus. `Lage.status` bleibt `ACTIVE`; `closeLage` muss auch `PAUSED` beenden |
| Grund der Abgabe | Enum `AbgabeGrund { AUSRUESTUNG_FEHLT, KEINE_EINHEIT_FREI, NICHT_UNSER_GEBIET, KEIN_FALL_FUER_FEUERWEHR, SONSTIGES }`. `meldungAnLeitstelleAbgeben(ausfuehrungId, grund, kommentar)`: Grund Pflicht, Kommentar nur bei `SONSTIGES` Pflicht. Feld `klaerungGrund` an der `Ausfuehrung` |
| Externe Übergabe | Neuer Endstatus `EreignisStatus.EXTERN_UEBERGEBEN`. `meldungExternUebergeben(ausfuehrungId, stelle, kommentar)` mit `stelle` als Enum `ExterneStelle { BAUHOF, THW }` (später konfigurierbar je Kommune). Felder `externeStelle`, `externUebergebenAt`. Nur Leitstelle, erlaubt aus jedem offenen Status. Erscheint in `lageMeldungen(offen: false)`, Bürgerstatus `ABGESCHLOSSEN` |
| Ausrüstung der Einheit | `Einheit.ausruestung: [String!]!` (Begriffe wie „Motorkettensäge“, „Drehleiter“, „Pumpe“, „Absperrung“), Migration, `einheiten[].ausruestung` in `seed.json`, Parameter in `createEinheit` |
| Einschätzung je Meldung | Beim Eingang (`ausfuehrungCreateAnonym`) einmal bestimmen und an der `Ausfuehrung` speichern: `benoetigteAusruestung: [String!]`, `klasse` (`A`–`D`), `moeglicherNotfall: Boolean`. `meldungKlasseSetzen` und `meldungAusruestungSetzen` für Korrekturen der Einsatzleitung oder Leitstelle |
| Notfall prüfen | `meldungNotfallPruefen(ausfuehrungId, ergebnis: AN_ELS_UEBERGEBEN \| KEIN_NOTFALL)`, speichert Ergebnis, Zeit und Bearbeiter; nur Leitstelle |
| Bestimmung | LLM-Aufruf im Backend, Schlüssel nur per Konfiguration. Für Demo und Tests ein regelbasierter Fallback ohne Schlüssel (Stichwörter wie „Baum“/„Ast“ → Motorkettensäge, „Dach“ → Drehleiter + Absperrung, „Keller“/„überflutet“ → Pumpe, „eingeklemmt“/„noch drin“ → möglicher Notfall) |

Gestrichen gegenüber dem Stand vom 21.11.: KI-Lagebild, Dringlichkeit je Meldung, NINA-Textvorlage im Dashboard.

---

## 6. Technischer Rahmen

- **Ort:** `web/bereich-a/src/routes/lage/` erweitern, z. B. `routes/lage/dashboard/` mit Routen `/lage/einsatzleitung` und `/lage/leitstelle`. Route-Definition und Rechteprüfung siehe `routes/lage/index.tsx` (`IfFunktionsberechtigung` mit `GlobaleFunktionsberechtigung.LageHelfer`), Menüeintrag in `components/user-menu/menu-items.tsx`.
- **Wiederverwenden:** `PageShell`/`PageHeader` (`components/page-shell.tsx`), `Button` (`components/ui/button`), `Modal` (`components/modal`), Status-Labels und -Übergänge für Gebiete in `routes/lage/lage-status.tsx`, GraphQL-Fragmente in `routes/lage/lage.graphql`.
- **GraphQL:** Operationen in `*.graphql` neben der Komponente, `pnpm graphql` (läuft in `pnpm dev` im Watch-Modus) erzeugt `*.generated.ts` mit Hooks. Fehler in Mutations kommen mit HTTP 200 im Feld `errors`, immer `errors { __typename ... on Error { message } }` abfragen.
- **Karte:** `maplibre-gl` 6 ist da, Theme in `utils/map-theme.ts`, Beispiel in `routes/antraege/detail/components/felder/location-formular-feld.tsx`. **Fallstrick:** Ohne `maplibregl.setWorkerUrl(maplibreWorkerUrl)` bleibt die Karte unter Vite leer, ohne Fehlermeldung (siehe Beispieldatei, Zeile 11).
- **Drag & Drop:** keine Bibliothek im Projekt. Natives HTML5-DnD reicht für den Prototyp; wer `@dnd-kit` nimmt, stimmt das kurz ab. Auswahl per Klick muss dieselbe Passt-Anzeige auslösen wie das Ziehen (Tastatur- und Touch-Bedienung).
- **Layout:** Der Mock ist für ≥ 1280 px gebaut (drei Spalten). Darunter genügt es, die Spalten zu stapeln.
- **Code-Konventionen:** `ha-py-app/CLAUDE.md` (Variablen englisch, Fachbegriffe deutsch; keine erzählenden Kommentare; Conventional Commits mit Scope `bereich-a` und `Changelog:`-Trailer).

**Lokal starten:** Setup und Seed siehe [lagehelfer-seeding-lokal.md](../lagehelfer-seeding-lokal.md). Danach `task start` im Repo-Root, Backoffice auf http://localhost:3000, GraphQL/Nitro auf http://localhost:5000/graphql. Für einen Token im Browser nach dem Login: `JSON.parse(atob(sessionStorage.__ka_session)).token`.

### 6a. Design System und Farben

Der Mock nutzt Inter und eigene Hex-Werte. **Nicht übernehmen**: Gebaut wird mit den Tokens von bereich-a (`src/index.css`, `tailwind.config.js`), die auch im gemeinsamen Design System `kommuna-ds/app.css` stehen.

- **Schrift:** `font-sans` = Century Gothic, kein Inter.
- **Grautöne:** Mock `#15191F` / `#59616E` / `#DDE1E7` / `#F3F4F6` → `gray-900` / `gray-700` / `gray-300` / `gray-100`.
- **Primäraktionen** (Zuweisen, Auswahlrahmen, aktiver Filter): `primary`. Achtung, `primary` wechselt je Kommune (`data-kommune`: Hameln-Pyrmont grün, Weserbergland rot). Deshalb darf **keine Status- oder Bedeutungsfarbe** von `primary` abhängen.

**Entschieden:** Semantische Tokens ergänzen, in `kommuna-ds/app.css` und in bereich-a (`src/index.css` + `tailwind.config.js`), im selben `R G B`-Format wie die bestehenden. Startwerte aus dem Mock:

| Token | Fläche / Text / Akzent | Verwendung |
|---|---|---|
| `danger` | `#FDECEA` / `#8A1C12` / `#B42318` | Notfall, Verwerfen, „✗ fehlt“, Klasse A (Akzent als Fläche, Text weiß) |
| `warning` | `#FFF8F0` / `#7A3A00` / `#C2410C` | Klärung, lange Wartezeit, „!“-Marker |
| `success` | `#E3F4E8` / `#12452A` / `#1D6B36` | „✓ passt“, Lage-Pill aktiv |
| `klasse-b` | `#FDF0E1` / `#7A3A00` | Badge „B · wichtig“ |
| `klasse-c` | `#FBF3D0` / `#5E4B00` | Badge „C · dringend“ |
| `bedarf` | `#EFE9FB` / `#4B2A99` | Chip „Braucht“ |
| `kategorie-1` | `#E8EBFB` / `#2A3699` / `#3B4CCA` | im Mock Sturm (Badge, Marker) |
| `kategorie-2` | `#DFF2F4` / `#0B5761` / `#0E6E7A` | im Mock Überschwemmung |

Kategorien kommen aus den Prozessdaten (Abschnitt 8), deshalb nummerierte Kategorie-Tokens und eine Zuordnung Kategorie → Token im Frontend statt fester Namen. Kontraste der Textfarben auf ihren Flächen vor dem Commit prüfen (WCAG AA).

---

## 7. Mock-Daten (als Fixture übernehmen)

**Lage:** „Sturm“, aktiv seit 14:20, „jetzt“ = 16:32. B-Team: 4 Plätze besetzt, ≈ 4–5 Notrufplätze entlastet.

**Einsatzleitungen (Mock):**
- *Nord*: Hameln, Hessisch Oldendorf, Bad Münder, Coppenbrügge, Salzhemmendorf.
- *Süd*: Aerzen, Emmerthal, Bad Pyrmont (laut Tabelle). 3 Einheiten, Namen nicht im Mock; frei erfinden.

**Einheiten Nord:**

| Einheit | An Bord | Zugeordnet |
|---|---|---|
| HLF 20 Hameln | Motorkettensäge, Pumpe, Absperrung | E-1031 (Status 4) |
| TLF 3000 Hessisch Oldendorf | Pumpe, Absperrung | – |
| DLK 23/12 Hameln | Drehleiter, Motorkettensäge, Absperrung | – |
| MTW Coppenbrügge | Motorkettensäge | – |

**Ereignisse:**

| ID | Kl. | Kategorie | Titel | Gemeinde · Ortsteil | EL | Status | +1 | wartet | Braucht / Einheit / Klärung |
|---|---|---|---|---|---|---|---|---|---|
| E-1042 | A | Sturm | Baum liegt quer über der Fahrbahn | Hameln · Wohngebiet Nord | Nord | eingegangen | 7 | 2 h 10 min | Motorkettensäge |
| E-1053 | B | Überschwemmung | Straße überflutet, Gully läuft über | Hameln · Innenstadt | Nord | eingegangen | 5 | 40 min | Pumpe, Absperrung |
| E-1051 | B | Sturm | Dachziegel lose, fallen auf Gehweg | Bad Münder · Ortskern | Nord | eingegangen | 3 | 55 min | Drehleiter, Absperrung |
| E-1058 | C | Sturm | Großer Ast auf Spielplatz | Coppenbrügge | Nord | eingegangen | 1 | 15 min | Motorkettensäge |
| E-1047 | C | Überschwemmung | Keller vollgelaufen, ca. 30 cm Wasser | Hessisch Oldendorf | Nord | eingegangen | 0 | 1 h 25 min | Pumpe |
| E-1049 | B | Überschwemmung | Unterführung überflutet | Emmerthal | Süd | eingegangen | 4 | 1 h 05 min | |
| E-1044 | C | Sturm | Bauzaun umgeweht | Bad Pyrmont | Süd | zugewiesen | 2 | 1 h 30 min | |
| E-1031 | A | Sturm | Baum auf geparktem Pkw | Hameln | Nord | in Bearbeitung | 2 | – | HLF 20 Hameln |
| E-1046 | B | Überschwemmung | Wasser im Keller des Gemeindehauses | Aerzen | Süd | in Klärung (2 h 20 min) | 0 | 2 h 20 min | Keine Einheit frei: „Alle Pumpen im Einsatz“ |
| E-1039 | C | Sturm | Mehrere Bäume auf Waldweg | Salzhemmendorf | Nord | in Klärung (35 min) | 1 | 35 min | Ausrüstung fehlt: „Radlader nötig“ |

**Möglicher Notfall:** E-1063 · Bad Pyrmont · „Baum aufs Haus gefallen, Nachbarin noch drin“ · Bürger wurde zur 112 geleitet.

**Demo-Fälle für die Passt-Anzeige:** E-1042 auswählen ⇒ HLF, DLK und MTW grün, TLF rot („fehlt: Motorkettensäge“). E-1051 auswählen ⇒ nur DLK grün.

Die Kennzahlen im Mock (8 / 9 / 2 / 17 bzw. 5 / 3 / 2 / 11) passen nicht exakt zu den sichtbaren Zeilen. Im Prototyp aus den Daten berechnen, nicht hart codieren. Zum Auffüllen ein paar erledigte Ereignisse ergänzen.

---

## 8. Abweichungen zwischen Mock und echten Seed-Daten

1. **Zuschnitt der Einsatzleitungen:** Der Mock hat zwei große Einsatzleitungen *Nord/Süd*. Im KRL-Seed hat jeder Bereich (= Gemeinde) seine eigene Einsatzleitung („Einsatzleitung Hameln“, „Einsatzleitung Bad Münder“ …); zwei Landkreise als Organisationseinheiten (Hameln-Pyrmont, Holzminden). Das Datenmodell erlaubt eine Gruppe für mehrere Gebiete (`addGebietEinsatzleitung`), Nord/Süd wäre also nachbildbar. **Für den Prototyp: Mock-Zuschnitt Nord/Süd verwenden**, Zuschnitt in der Datenschicht konfigurierbar halten.
2. **Salzhemmendorf** hat im Seed keine Einsatzleitung, im Mock gehört es zu Nord.
3. **Kategorien:** Mock nutzt *Sturm*/*Überschwemmung*, der Seed-Prozess hat *Unwetter*, *Großbrand*, *Hagelsturm*, *Blitzeis*. Kategorien und Farben daher nicht fest verdrahten (Abschnitt 6a).
4. **Lage vs. Kategorie:** Die Lage heißt „Sturm“, enthält aber auch Überschwemmungs-Ereignisse. Kategorie ist also eine Eigenschaft des Ereignisses, nicht der Lage.
5. **Einheiten:** Seed-Einheiten haben noch keine Ausrüstung; die DLK 23/12 Hameln ist im Seed ggf. zu ergänzen.

---

## 9. Offene Fragen (bitte mit Produkt/Team klären, nicht blockierend)

- Wann wird aus *zugewiesen* ein *in Bearbeitung*: durch die Einheit, die Einsatzleitung oder automatisch?
- Darf eine Einsatzleitung Ereignisse zwischen eigenen Einheiten umhängen oder zurück in den Eingang ziehen?
- Soll die Leitstelle auch Einheiten sehen/verschieben können oder nur Einsatzleitungen?
- Schwellwert für die Wartezeit-Hervorhebung?
- Drop auf eine Einheit mit „✗ fehlt“: blockieren oder mit Rückfrage trotzdem zuweisen?
- Ersetzt die Klasse A–D den Slot `prioritaet` (Hoch/Niedrig), oder gibt es beides?
- Bestimmung von Klasse, Bedarf und Notfall in der Demo: echter LLM-Aufruf oder regelbasierter Fallback?
- Produktname: „Lagehelfer“ oder „DEICH“?

**Entschieden am 22.11.:**
- Abgabe an die Leitstelle: Grund Pflicht, Kommentar nur bei *Sonstiges* Pflicht.
- Bauhof/THW: externe Übergabe mit eigenem Endstatus, keine eigenen Mitarbeitergruppen.
- Meldeweg: umkehrbar pausieren im Dashboard, endgültiges Beenden bleibt in `/lage`.
- Farben: semantische Tokens im Design System, unabhängig von `primary`.

---

## 10. Fertig, wenn …

- [ ] Beide Ansichten entsprechen dem Mock in Aufbau und Verhalten, mit Schrift und Farben aus dem Design System (6a), und sind über „Ansicht“ umschaltbar, eingeloggt mit einem KRL-Demo-User.
- [ ] Einsatzleitung: Eingang nach Klasse, +1 und Wartezeit sortiert; Filter Alle / Klasse A / Kategorie / +1 ab 3 funktionieren.
- [ ] Einsatzleitung: Ereignis anklicken oder ziehen → Einheiten zeigen „✓ passt“ / „✗ fehlt: …“; Kopf zeigt „Gezogen: E-… · braucht …“.
- [ ] Einsatzleitung: Ereignis auf eine Einheit ziehen → Eingang, Einheit (Status 4), Kennzahlen und Karte aktualisieren sich.
- [ ] Einsatzleitung: „Erledigt“ → verschwindet aus der Einheit, Zähler „erledigt“ steigt, Einheit wird Status 2, wenn leer.
- [ ] Einsatzleitung: „An Leitstelle abgeben“ → Inline-Formular mit Grund (Pflicht) und Kommentar → erscheint in der Leitstelle unter „Klärung“ mit Grund, Kommentar und „!“ auf der Karte.
- [ ] Leitstelle: Klärung an andere Einsatzleitung zuweisen → im Eingang dort. An Bauhof/THW → im Archiv als extern übergeben. Schließen mit Begründung → im Archiv.
- [ ] Leitstelle: Tabelle mit Klassen-Spalte filtert nach Offen / Einsatzleitung / Archiv; Umverteilen und Verwerfen funktionieren.
- [ ] Leitstelle: „Offline nehmen“ → Pill „Inaktiv · Meldeweg geschlossen“, Bürger-App ohne Button, offene Ereignisse bleiben bearbeitbar. „Online nehmen“ stellt den Meldeweg wieder her.
- [ ] Leitstelle: Notfall-Kachel mit „An ELS übergeben (EIDO)“ und „Geprüft, kein Notfall“, beide nehmen den Treffer aus der Liste.
- [ ] Karten zeigen echte Gebietspolygone aus `gebiete.geometry`; Marker je Ereignis mit Kategoriefarbe und +1-Zahl.
- [ ] Daten kommen aus der API, wo sie existiert (Abschnitt 5); Felder aus 5a laufen über die Datenschicht und lassen sich ohne UI-Änderung auf die API umstellen.
