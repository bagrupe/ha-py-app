# LageHelfer-Demodaten lokal einspielen

Wenn laut README Docker, CMS-Seed und Backend schon laufen, fehlt für den Hackathon-Mandanten **Kooperative Regionalleitstelle Weserbergland** (KRL) nur noch das Einspielen von `seed.json` und `flaechen.geojson`. Zwei Starts: Backend legt Struktur und Demo-User an, Bereich B legt die Kommune im CMS an.

English: [lagehelfer-seeding-local.en.md](./lagehelfer-seeding-local.en.md)

## Seed-Daten holen

Download-Link und Zugangsdaten erhalten Teilnehmende separat vom Veranstaltungsteam. Sie werden nicht im öffentlichen Repository veröffentlicht.

Im Archiv müssen mindestens `seed.json` und `flaechen.geojson` liegen. Die Dateien stehen nicht im Repo.

## Ablegen

Alles ins Verzeichnis `backend/API/Seeders/LageHelfer/Data/krl/` (Ordner bei Bedarf anlegen). Der Development-Standard verwendet die mitgelieferten Beispieldaten. Für KRL muss der Pfad wie unten gezeigt explizit überschrieben werden.

```text
backend/API/Seeders/LageHelfer/Data/krl/
├── seed.json
└── flaechen.geojson
```

Optinal: Überprüfen ob die Daten richtig angelegt sind:

```bash
test -f backend/API/Seeders/LageHelfer/Data/krl/seed.json \
  -a -f backend/API/Seeders/LageHelfer/Data/krl/flaechen.geojson \
  && echo "OK" || echo "Dateien fehlen"
```


## Backend

Unter Development ist LageHelfer in `appsettings.Development.json` schon an (`LageHelferEnabled: true`, Pfad `example`, ausschließlich lokaler Demo-Key). Ohne Cloud-Zugang funktionieren die mitgelieferten Beispieldaten. Für die separat bereitgestellten KRL-Daten in `backend/API/.env` den Pfad überschreiben. Der Seeder läuft bei jedem Backend-Start und ist idempotent.

Wer in `backend/API/.env` eigene `DataSeeder__*`-Werte setzt, darf LageHelfer nicht ausschalten:

```bash
DataSeeder__LageHelferEnabled=true
DataSeeder__LageHelferSeedPath=Seeders/LageHelfer/Data/krl
DataSeeder__LageHelferKeyEncryptionKey=fbqTzzZyfSPyAGBbyJZ30EMimLVpcNr+Crv8AvzHohU=
```

Nach dem Ablegen der Dateien Backend neu starten (`task backend` oder `task stop` / `task start`).

## Bereich B (Inhaltspflege)

In `web/bereich-b/.env` (Werte müssen zu `kommune` in `seed.json` passen; beim KRL-Paket):

```bash
ENABLE_LAGEHELFER_SEED=true
LAGEHELFER_KOMMUNE_ID=84a06067-dc9e-46d0-b60a-8258cf7c1ce7
LAGEHELFER_KOMMUNE_NAME=Kooperative Regionalleitstelle Weserbergland
LAGEHELFER_REGIONALSCHLUESSEL=03252
LAGEHELFER_DEFAULT_POSITION=51.9786,9.4264
```

Bereich B neu starten (`task web`). Die Kommune wird beim Start angelegt.

## Prüfen

- Backoffice: http://localhost:3000, Demo-User aus `seed.json`, Zugangsdaten werden separat vom Veranstaltungsteam bereitgestellt

Beispiel-Logins:

| E-Mail | Rolle |
| :--- | :--- |
| `superadmin-krl@example.com` | Superadmin |
| `admin-krl@example.com` | Admin der Landkreise |
| `einsatzleitung-hameln@example.com` | Einsatzleitung Hameln-Pyrmont |
| `einsatzleitung-holzminden@example.com` | Einsatzleitung Holzminden |

## Wenn etwas hängt

**Fehlende oder kaputte `seed.json`:** Pfad `.../Data/krl/` prüfen, Archiv vollständig entpackt? Format siehe `docs/entwickler/lagehelfer-importformat.adoc`.

**`LageHelfer seeder failed` im CMS-Log:** `LAGEHELFER_KOMMUNE_ID` und `LAGEHELFER_KOMMUNE_NAME` fehlen oder weichen von `seed.json` ab. Werte aus der Datei übernehmen, Bereich B neu starten.

**Keine KRL-User im Backoffice:** Backend nach dem Ablegen der Daten neu gestartet? In `.env` kein `DataSeeder__LageHelferEnabled=false`. Demo-User kommen nur in Nicht-Production aus dem `demo`-Abschnitt der `seed.json`.

Mehr zum Datenformat: `docs/entwickler/lagehelfer-seeding.adoc`, `docs/entwickler/lagehelfer-importformat.adoc`.
