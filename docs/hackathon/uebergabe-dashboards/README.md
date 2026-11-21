# Übergabe: Frontend-Prototyp Backoffice „Leitstelle & Einsatzleitung“

Stand 21.11.2026. Quelle: Mock „Lagehelfer – Dashboards Leitstelle & Einsatzleitung“ ([PDF](assets/mock-dashboards-und-buergerflow.pdf)). Deine Aufgabe sind **Seite 1 (Einsatzleitung) und Seite 2 (Leitstelle)**. Seiten 3–10 zeigen den Bürger-Flow und sind nur Kontext: Was die Leitstelle schaltet, sieht die Bürgerin dort (Button „Vorfall melden“, Meldung, Status).

## Kurzfassung

- Gebaut wird im bestehenden Backoffice **`web/bereich-a`** (React 19, Vite, Tailwind 3, react-router 7, urql + GraphQL-Codegen, MapLibre). Dort gibt es unter `/lage` schon eine schlichte Lage-Verwaltung, an die du andocken kannst.
- Zwei Ansichten, umschaltbar über „Ansicht“ oben rechts: **Einsatzleitung** (ein Zuständigkeitsgebiet, Ereignisse auf Einheiten verteilen) und **Leitstelle** (Gesamtlage, Lage steuern, abgegebene Ereignisse klären).
- Die API deckt die Dashboards fast vollständig ab: Meldungen einer Lage mit Nummer, Status und +1-Zähler, Einheiten, Zuweisen, Klärung, Umverteilen, Verwerfen, Lage beenden und Bürger-Hinweis (Tabelle in Abschnitt 5). Nur der NINA-Status ist nicht im Backend.
- Ziel ist ein klickbarer Prototyp für die Demo, kein Produktivcode: Drag & Drop, Statuswechsel und Klärung müssen sich echt anfühlen.

---

## 1. Rollen und Ansichten

| Ansicht | Wer | Sieht | Demo-Login (lokal) |
|---|---|---|---|
| Einsatzleitung | Mitarbeitergruppe, die für ein oder mehrere Gebiete zuständig ist | nur Ereignisse und Einheiten des eigenen Zuständigkeitsgebiets | `einsatzleitung-hameln@example.com` |
| Leitstelle | Admin / Superadmin der KRL | alle Gebiete, alle Einsatzleitungen, Lage-Steuerung | `admin-krl@example.com`, `superadmin-krl@example.com` |

Passwort: `demo.passwort` in `Dokumente/seed.json` (nicht ins Repo schreiben, das Repo ist öffentlich). Alle vier Demo-User haben das globale Recht `LageHelfer`.

Der Umschalter „Ansicht“ im Mock ist ein Demo-Hilfsmittel. Im Prototyp reicht: Vorauswahl aus der Rolle des eingeloggten Users, manuell umschaltbar. **Rollen werden im Backend nicht pro Gebiet geprüft**, jeder mit `LageHelfer` darf alles. Trennung also clientseitig über `my { ... on Mitarbeiter { gruppen { id name } } }` gegen `gebiet.einsatzleitungen`.

---

## 2. Ansicht Einsatzleitung (Mock Seite 1)

![Einsatzleitung](assets/mock-einsatzleitung.png)

**Kopfzeile (beide Ansichten gleich):** Logo „Lagehelfer“, Breadcrumb „Backoffice · Einsatzleitung“, Lage-Pill „● Lage Sturm aktiv · seit 14:20“ (nur sichtbar, wenn eine Lage aktiv ist), Ansicht-Dropdown, „Aktualisiert 16:32“ (Zeitpunkt des letzten Datenabrufs).

**Titelzeile:** Name der Einsatzleitung + Liste der Gemeinden im Zuständigkeitsgebiet. Rechts vier Kennzahlen: *Neu, nicht zugewiesen* · *Zugewiesen* · *In Bearbeitung* · *Erledigt seit Lagebeginn*.

**Spalte 1 – Eingang**
- Nur Ereignisse im Status *eingegangen* (noch keiner Einheit zugewiesen).
- Sortierung: zuerst nach +1-Anzahl absteigend, dann nach Wartezeit absteigend.
- Filter-Chips: *Alle* + je Kategorie (im Mock *Sturm*, *Überschwemmung*).
- Karte je Ereignis: Kategorie-Badge (Farbe je Kategorie), ID (`E-1042`), +1-Zähler rechts, Titel, `Gemeinde · Ortsteil`, Fotoanzahl, Wartezeit. Wartezeit über einem Schwellwert farbig hervorheben (im Mock orange bei 2 h 10 min; Schwelle festlegen, Vorschlag 2 h).
- Karten sind **ziehbar** (Drag-Quelle).

**Spalte 2 – Karte**
- OSM-Hintergrund, Ausschnitt auf das Zuständigkeitsgebiet (Polygone der Gebiete).
- Ein Marker je offenem Ereignis, Farbe = Kategorie, Zahl im Marker = +1-Anzahl, daneben die ID.
- Wünschenswert: Hover/Klick auf Marker hebt die Karte im Eingang hervor und umgekehrt.

**Spalte 3 – Einheiten**
- Kachel je Einheit: Name (z. B. „HLF 20 Hameln“), Status-Badge *frei* / *im Einsatz* (abgeleitet: im Einsatz, sobald mindestens ein Ereignis zugeordnet ist).
- Darin die zugeordneten Ereignisse mit ID, Kurztitel, Status (*zugewiesen* / *in Bearbeitung*) und Button **Erledigt**.
- Drop-Zone „Ereignis hierher ziehen“. Drop ⇒ Ereignis wird *zugewiesen*, verschwindet aus dem Eingang.
- Unten Drop-Zone **„An Leitstelle abgeben“**: Drop öffnet einen Dialog mit **Pflicht-Kommentar** (Beispiel „Kettensäge fehlt“). Danach Status *in Klärung*, Ereignis taucht in der Leitstelle unter „Klärung“ auf.

Offen im Mock: Wie wird aus *zugewiesen* ein *in Bearbeitung*? Die API bietet dafür `meldungFortsetzen(HILFE_EINLEITEN)`; Vorschlag: Klick auf das Ereignis in der Einheit oder ein zweiter Button „Hilfe eingeleitet“. Bitte mit uns abstimmen.

---

## 3. Ansicht Leitstelle (Mock Seite 2)

![Leitstelle](assets/mock-leitstelle.png)

**Lage-Kachel (oben links)**
- Titel „Lage Sturm“, Badge „aktiv seit 14:20 · 2 h 12 min“.
- Drei Statusfelder: *Meldeweg* (offen/geschlossen), *Ha-Py Button* (sichtbar/ausgeblendet), *NINA-Hinweis* (versendet + Uhrzeit).
- **Lage beenden** (rot, mit Bestätigungsdialog). Text darunter beschreibt die Wirkung: keine neuen Meldungen, Button in der Bürger-App weg, offene Ereignisse bleiben bis zur Erledigung sichtbar.
- **Hinweise für Bürger bearbeiten**: Dialog für den Text, den die Bürger-App im Lage-Banner zeigt (Mock Seite 3).
- Wünschenswert für die Demo: Ohne aktive Lage zeigt die Kachel „Lage ausrufen“ (Titel, Gebiete wählen). Das gibt es im Mock nicht, macht die Demo aber rund.

**Kennzahlen (oben rechts):** *Neu, nicht zugewiesen* · *Zugewiesen / in Bearbeitung* · *In Klärung* (hervorgehoben, sobald > 0) · *Erledigt seit Lagebeginn* · je Einsatzleitung eine Kachel „5 neu · 2 von 4 Einheiten frei“.

**Klärung (Mitte links)**
- Alle abgegebenen Ereignisse, älteste zuerst.
- Karte: Kategorie, ID, Gemeinde, „in Klärung seit …“, Titel, Kommentar der abgebenden Einsatzleitung.
- Aktionen: Dropdown „Neu zuweisen an“ (andere Einsatzleitung, vorbelegt mit einer, die nicht abgegeben hat) + **Zuweisen**; **Schließen mit Begründung** (Dialog, Pflichttext).

**Gesamtlage (Mitte rechts):** Karte des ganzen Landkreises, Gebiete der Einsatzleitungen als eingefärbte Flächen mit Label, Marker wie bei der Einsatzleitung, Ereignisse in Klärung als rotes „!“.

**Alle Ereignisse (unten)**
- Tabelle: ID · Kategorie · Ereignis · Gemeinde · Einsatzleitung · Status-Badge · +1 · Wartet · Aktionen.
- Filter-Tabs: *Offen* · je Einsatzleitung (*Nord*, *Süd*) · *Archiv* (erledigt/verworfen).
- Aktionen je Zeile: **Umverteilen** (an andere Einsatzleitung), **Bearbeiten** (Kategorie, Titel, Ort korrigieren), **Verwerfen** (rot, Bestätigung mit Begründung).

---

## 4. Statusmodell eines Ereignisses

Das Backend liefert den Stand direkt als `Ausfuehrung.ereignisStatus` (`EreignisStatus`). Die Aktionen sind eigene Mutations:

```
EINGEGANGEN ──meldungEinheitZuweisen──▶ ZUGEWIESEN ──meldungFortsetzen(HILFE_EINLEITEN)──▶ IN_BEARBEITUNG
     ▲   │                                   │                                                │
     │   │                                   └──────meldungFortsetzen(EINSATZ_ABSCHLIESSEN)───┴──▶ ERLEDIGT
     │   └──meldungAnLeitstelleAbgeben(kommentar)──▶ IN_KLAERUNG
     │                                                  │
     └────────────meldungUmverteilen(gruppe)────────────┤   (Leitstelle, auch direkt aus der Tabelle)
                                                        └──meldungVerwerfen(begruendung)──▶ VERWORFEN
```

- `meldungEinheitZuweisen(einheitId: null)` legt die Meldung zurück in den Eingang.
- `meldungFortsetzen(EINSATZ_ABSCHLIESSEN)` geht bei Bedarf vorher automatisch „Hilfe einleiten“. Der Button „Erledigt“ funktioniert also auch bei *zugewiesen*.
- „Verwerfen“ (Tabelle) und „Schließen mit Begründung“ (Klärung) sind dieselbe Mutation `meldungVerwerfen`.
- Bürgerseite (`ausfuehrungStatusAnonym`, `MeldungStatus`): ZUGEWIESEN → `IN_BEARBEITUNG`, IN_BEARBEITUNG → `HILFE_UNTERWEGS`, ERLEDIGT und VERWORFEN → `ABGESCHLOSSEN`. Die Begründung sehen Bürger:innen nicht.

---

## 5. Datenlage: was die API liefert

Endpunkte, Token und Rezepte: Skill `.agents/skills/graphql-api` (vor allem `references/lagehelfer.md`). Schema: `web/bereich-a/schema.graphql`.

| UI-Element | Quelle | Hinweis |
|---|---|---|
| Lage-Pill, Titel, „aktiv seit“ | ✅ `lagen(status: ACTIVE)` → `title`, `gebiete[].liveAt` | „seit“ = frühestes `liveAt` |
| Meldeweg offen / Ha-Py Button sichtbar | ✅ abgeleitet | offen, solange mindestens ein `LageGebiet` `LIVE` ist |
| Gebiete, Polygone, Einsatzleitung je Gebiet | ✅ `gebiete { geometry einsatzleitungen { id name } }` | `geometry` ist ein GeoJSON-String → `JSON.parse` |
| Ereignisse einer Lage | ✅ `lageMeldungen(lageId, offen)` | Leitstelle (Admin/Superadmin) sieht alle, Einsatzleitung nur die ihrer Gruppen. `offen: false` = Archiv |
| Kurz-ID `E-1042` | ✅ `meldungsnummer` | Zahl ab 1000, Präfix „E-“ setzt das Frontend. Auch in `ausfuehrungCreateAnonym` und `ausfuehrungStatusAnonym` |
| Status-Badge | ✅ `ereignisStatus` | siehe Abschnitt 4 |
| Kategorie, Beschreibung, Fotos, Standort | ✅ `slotValues` (Slots `kategorie`, `beschreibung`, `bilder`, `adresse`) | unverschlüsselt (`PlainSlotValue`). Verschlüsselt sind nur `rueckrufnummer`, `prioritaet`, `interneNotiz`; Entschlüsseln wie in `components/ui/decrypt-value.tsx` |
| Gemeinde | ✅ `Ausfuehrung.lage.gebietName` | Ortsteil („Wohngebiet Nord“) gibt es nicht, ggf. aus Adresse |
| Einsatzleitung eines Ereignisses | ✅ `istZustaendigkeit.mitarbeiterGruppe` | |
| Wartezeit | ✅ `createdAt` | |
| **+1-Zähler** | ✅ `anzahlBestaetigungen`, Details in `bestaetigungen { createdAt fotos }` | Bürger-App: `activeLagen.meldungen { id kategorie anzahlBestaetigungen }` und `meldungBestaetigen(publicId, fotos)` |
| **Einheiten** | ✅ `einheiten(mitarbeiterGruppeId)`, `createEinheit`, `deleteEinheit`, `Ausfuehrung.einheit` | „frei / im Einsatz“ aus den offenen Meldungen je Einheit ableiten. Demo-Einheiten über `einheiten` je Bereich in `seed.json` |
| Ereignis auf Einheit ziehen | ✅ `meldungEinheitZuweisen` | nur Einheiten der zuständigen Einsatzleitung |
| „Erledigt“ / in Bearbeitung | ✅ `meldungFortsetzen(aktion)` | geht die Prozess-Kanten, Bürger:innen sehen den neuen Stand |
| **An Leitstelle abgeben, Klärung** | ✅ `meldungAnLeitstelleAbgeben(kommentar)`, `klaerungSeit`, `klaerungKommentar` | Kommentar ist Pflicht |
| Neu zuweisen / Umverteilen | ✅ `meldungUmverteilen(mitarbeiterGruppeId)` | nur Leitstelle |
| Verwerfen / Schließen mit Begründung | ✅ `meldungVerwerfen(begruendung)`, `verwerfenGrund` | nur Leitstelle |
| **Lage beenden** | ✅ `closeLage(lageId)` | beendet alle laufenden Gebiete, `Lage.status = CLOSED`; offene Meldungen bleiben in `lageMeldungen` |
| **Hinweise für Bürger** | ✅ `updateLageWarningText(lageId, warningText)` | erscheint in `activeLagen.warningText` |
| **NINA-Hinweis** | ❌ | rein anzeigen/mocken |
| Live-Aktualisierung | ⚠️ keine Subscriptions | Polling, z. B. alle 15 s mit `requestPolicy: 'network-only'`, „Aktualisiert“ = letzter Abruf |

Alle Mutations liefern fachliche Fehler im Feld `errors` (z. B. `MeldungInKlaerungError`, `NotAllowedError`), immer `errors { __typename ... on Error { message } }` abfragen. Rollen: Admin und Superadmin gelten als Leitstelle, Nutzer mit Gruppe als deren Einsatzleitung. Alle brauchen das globale Recht `LageHelfer`.

**Empfehlung:** Echte API verwenden; nur der NINA-Status bleibt gemockt. Falls das Backend in der Demo nicht läuft, eine dünne Datenschicht (`useLageDashboard()` o. ä.) mit Mock-Variante auf Basis der Daten in Abschnitt 7 vorsehen.

---

## 6. Technischer Rahmen

- **Ort:** `web/bereich-a/src/routes/lage/` erweitern, z. B. `routes/lage/dashboard/` mit Routen `/lage/einsatzleitung` und `/lage/leitstelle`. Route-Definition und Rechteprüfung siehe `routes/lage/index.tsx` (`IfFunktionsberechtigung` mit `GlobaleFunktionsberechtigung.LageHelfer`), Menüeintrag in `components/user-menu/menu-items.tsx`.
- **Wiederverwenden:** `PageShell`/`PageHeader` (`components/page-shell.tsx`), `Button` (`components/ui/button`), `Modal` (`components/modal`), Status-Labels und -Übergänge für Gebiete in `routes/lage/lage-status.tsx`, GraphQL-Fragmente in `routes/lage/lage.graphql`.
- **GraphQL:** Operationen in `*.graphql` neben der Komponente, `pnpm graphql` (läuft in `pnpm dev` im Watch-Modus) erzeugt `*.generated.ts` mit Hooks. Fehler in Mutations kommen mit HTTP 200 im Feld `errors`, immer `errors { __typename ... on Error { message } }` abfragen.
- **Karte:** `maplibre-gl` 6 ist da, Theme in `utils/map-theme.ts`, Beispiel in `routes/antraege/detail/components/felder/location-formular-feld.tsx`. **Fallstrick:** Ohne `maplibregl.setWorkerUrl(maplibreWorkerUrl)` bleibt die Karte unter Vite leer, ohne Fehlermeldung (siehe Beispieldatei, Zeile 11).
- **Drag & Drop:** keine Bibliothek im Projekt. Natives HTML5-DnD reicht für den Prototyp; wer `@dnd-kit` nimmt, stimmt das kurz ab.
- **Layout:** Der Mock ist für ≥ 1280 px gebaut (drei Spalten). Darunter genügt es, die Spalten zu stapeln.
- **Code-Konventionen:** `ha-py-app/CLAUDE.md` (Variablen englisch, Fachbegriffe deutsch; keine erzählenden Kommentare; Conventional Commits mit Scope `bereich-a` und `Changelog:`-Trailer).

**Lokal starten:** Setup und Seed siehe [lagehelfer-seeding-lokal.md](../lagehelfer-seeding-lokal.md). Danach `task start` im Repo-Root, Backoffice auf http://localhost:3000, GraphQL/Nitro auf http://localhost:5000/graphql. Für einen Token im Browser nach dem Login: `JSON.parse(atob(sessionStorage.__ka_session)).token`.

---

## 7. Mock-Daten aus dem PDF (als Fixture übernehmen)

**Lage:** „Sturm“, aktiv seit 14:20, NINA-Hinweis versendet 14:25, „jetzt“ = 16:32.

**Einsatzleitungen (Mock):**
- *Nord*: Hameln, Hessisch Oldendorf, Bad Münder, Coppenbrügge, Salzhemmendorf. Einheiten: HLF 20 Hameln, TLF 3000 Hessisch Oldendorf, RW Bad Münder, MTW Coppenbrügge.
- *Süd*: Aerzen, Emmerthal, Bad Pyrmont (laut Tabelle). 3 Einheiten, Namen nicht im Mock; frei erfinden.

| ID | Kategorie | Titel | Gemeinde · Ortsteil | EL | Status | +1 | Fotos | wartet | Einheit / Kommentar |
|---|---|---|---|---|---|---|---|---|---|
| E-1042 | Sturm | Baum liegt quer über der Fahrbahn | Hameln · Wohngebiet Nord | Nord | eingegangen | 7 | 2 | 2 h 10 min | |
| E-1053 | Überschwemmung | Straße überflutet, Gully läuft über | Hameln · Innenstadt | Nord | eingegangen | 5 | 1 | 40 min | |
| E-1051 | Sturm | Dachziegel auf dem Gehweg | Bad Münder · Ortskern | Nord | eingegangen | 3 | 1 | 55 min | |
| E-1058 | Sturm | Großer Ast auf Spielplatz | Coppenbrügge | Nord | eingegangen | 1 | 0 | 15 min | |
| E-1047 | Überschwemmung | Keller vollgelaufen, ca. 30 cm Wasser | Hessisch Oldendorf | Nord | eingegangen | 0 | 1 | 1 h 25 min | |
| E-1049 | Überschwemmung | Unterführung überflutet | Emmerthal | Süd | eingegangen | 4 | | 1 h 05 min | |
| E-1044 | Sturm | Bauzaun umgeweht | Bad Pyrmont | Süd | zugewiesen | 2 | | 1 h 30 min | |
| E-1031 | Sturm | Baum auf geparktem Pkw | Hameln | Nord | in Bearbeitung | 2 | | – | HLF 20 Hameln |
| E-1036 | Sturm | Bauzaun umgeweht | | Nord | zugewiesen | | | | HLF 20 Hameln |
| E-1040 | Überschwemmung | Keller unter Wasser | | Nord | in Bearbeitung | | | | RW Bad Münder |
| E-1046 | Überschwemmung | Wasser im Keller des Gemeindehauses | Aerzen | Süd | in Klärung (2 h 20 min) | 0 | | 2 h 20 min | „Alle Pumpen im Einsatz“ |
| E-1039 | Sturm | Mehrere Bäume auf Waldweg | Salzhemmendorf | Nord | in Klärung (35 min) | 1 | | 35 min | „Kettensäge und Radlader fehlen“ |

Die Kennzahlen im Mock (8 / 9 / 2 / 17 bzw. 5 / 3 / 2 / 11) passen nicht exakt zu den sichtbaren Zeilen. Im Prototyp aus den Daten berechnen, nicht hart codieren. Zum Auffüllen ein paar erledigte Ereignisse ergänzen.

---

## 8. Abweichungen zwischen Mock und echten Seed-Daten

1. **Zuschnitt der Einsatzleitungen:** Der Mock hat zwei große Einsatzleitungen *Nord/Süd*. Im KRL-Seed hat jeder Bereich (= Gemeinde) seine eigene Einsatzleitung („Einsatzleitung Hameln“, „Einsatzleitung Bad Münder“ …); zwei Landkreise als Organisationseinheiten (Hameln-Pyrmont, Holzminden). Das Datenmodell erlaubt eine Gruppe für mehrere Gebiete (`addGebietEinsatzleitung`), Nord/Süd wäre also nachbildbar. **Für den Prototyp: Mock-Zuschnitt Nord/Süd verwenden**, Zuschnitt in der Datenschicht konfigurierbar halten.
2. **Salzhemmendorf** hat im Seed keine Einsatzleitung, im Mock gehört es zu Nord.
3. **Kategorien:** Mock nutzt *Sturm*/*Überschwemmung*, der Seed-Prozess hat *Unwetter*, *Großbrand*, *Hagelsturm*, *Blitzeis*. Kategorien und Farben daher nicht fest verdrahten.
4. **Lage vs. Kategorie:** Die Lage heißt „Sturm“, enthält aber auch Überschwemmungs-Ereignisse. Kategorie ist also eine Eigenschaft des Ereignisses, nicht der Lage.

---

## 9. Offene Fragen (bitte mit Produkt/Team klären, nicht blockierend)

- Wann wird aus *zugewiesen* ein *in Bearbeitung*: durch die Einheit, die Einsatzleitung oder automatisch?
- Darf eine Einsatzleitung Ereignisse zwischen eigenen Einheiten umhängen oder zurück in den Eingang ziehen?
- Soll die Leitstelle auch Einheiten sehen/verschieben können oder nur Einsatzleitungen?
- Schwellwert für die Wartezeit-Hervorhebung?

---

## 10. Fertig, wenn …

- [ ] Beide Ansichten sehen aus wie im Mock und sind über „Ansicht“ umschaltbar, eingeloggt mit einem KRL-Demo-User.
- [ ] Einsatzleitung: Ereignis aus dem Eingang auf eine Einheit ziehen → Eingang, Einheit, Kennzahlen und Karte aktualisieren sich.
- [ ] Einsatzleitung: „Erledigt“ an einem Ereignis → verschwindet aus der Einheit, Zähler „Erledigt“ steigt, Einheit wird *frei*, wenn leer.
- [ ] Einsatzleitung: Ereignis auf „An Leitstelle abgeben“ → Dialog mit Pflicht-Kommentar → erscheint in der Leitstelle unter „Klärung“ mit Kommentar und rotem „!“ auf der Karte.
- [ ] Leitstelle: Klärung neu zuweisen → Ereignis im Eingang der anderen Einsatzleitung. Schließen mit Begründung → im Archiv.
- [ ] Leitstelle: Tabelle filtert nach Offen / Einsatzleitung / Archiv; Umverteilen und Verwerfen funktionieren.
- [ ] Leitstelle: „Lage beenden“ mit Bestätigung → Pill und Lage-Kachel zeigen beendet, Meldeweg geschlossen, offene Ereignisse bleiben sichtbar.
- [ ] Karten zeigen echte Gebietspolygone aus `gebiete.geometry`; Marker je Ereignis mit Kategoriefarbe und +1-Zahl.
- [ ] Daten kommen aus der API (`lageMeldungen`, `einheiten`, Mutations aus Abschnitt 4); gemockt ist nur der NINA-Status.
