# Bereinigung vor der Open-Source-Veröffentlichung

Stand: 2026-11-20. Geprüft wurde das gesamte Monorepo einschließlich App, Backend, Web, CI, Docker, Kubernetes, Monitoring, Dokumentation und Testdaten. Dieser Bericht enthält keine ursprünglichen Schlüsselwerte.

## Entfernte oder ersetzte Angaben

| Bereich | Fund und Maßnahme |
| --- | --- |
| Android/iOS Firebase | 11 Projektkonfigurationen mit API-Keys, Projekt-/Client-IDs entfernt; bereinigte `.example`-Vorlagen beigefügt. Originalpfade werden ignoriert. |
| Backend-Konfiguration | Payment-Salt und CMS-Superadmin-API-Key entfernt; produktiver JWT-Key muss extern konfiguriert werden. SMS-Mastercode im Basisprofil deaktiviert. Klar bezeichnete lokale Testwerte verbleiben in Development/Testing. |
| Backend-Seeder | Zwei fest hinterlegte private RSA-Schlüssel und der symmetrische Kommune-Schlüssel entfernt. Schlüssel kommen aus Umgebungsvariablen. Unit-Tests erzeugen eigenes Schlüsselmaterial im Testprozess. |
| Telemetrie | Vier eingebettete Sentry-DSNs entfernt; Projekt-/Organisationsvorgaben durch externe Konfiguration ersetzt. |
| CI, Infrastruktur, Signing | Interne Domains, Registry-, Zertifikatsrepository- und Apple-Team-Angaben ersetzt. Registry und Signing werden extern konfiguriert. |
| Import und Testdaten | Echte Kontaktadressen, ausgewählte Namen und Telefonnummern anonymisiert; Kategorieimport enthält nur noch eine Beispielzuständigkeit. |
| Dokumentation und Rechtstexte | Interne Passwortverwaltungs-, Datenbank-Dump- und Projektassistent-Links entfernt. Impressum und Datenschutzdatei sind ausdrücklich als auszufüllende Vorlagen gekennzeichnet. |
| Binäre Dokumentation | 44 Dokumentationsbilder/GIFs lokal mittels OCR geprüft; bei GIFs wurden Stichproben von Frames geprüft. Neun Bilder/GIFs mit nicht reservierten Beispieladressen oder Firmenkennung entfernt, ihre Dokumentationsreferenzen bereinigt. Verbleibende OCR-Befunde waren überwiegend synthetische example.com-Adressen. |
| Artefakte | Generierte HTML/PDF-Dokumentation, Android-Buildreport, TypeScript-Buildcache und API-Client-Export entfernt. Eingechecktes node_modules-Lockfile und Workspace-Symlink aus dem Git-Index entfernt; lokale Installation bleibt erhalten. |

Die vollständige Dateiliste steht in `publication-files.json`. Öffentliche Paketnamen, Abhängigkeitsreferenzen, Bibliothekslizenzen, kommunale Logos/Branding sowie öffentliche Datenanbieter-Schnittstellen bleiben erhalten. Das ist keine vollständige Umbenennung des Produkts.

## Erforderliche eigene Konfiguration

- Firebase: eigene Konfigurationen an den bisherigen Pfaden bereitstellen (siehe `.example` daneben). Die Vorlagen sind nicht funktionsfähige Zugangsdaten. Android/iOS-Builds und Push benötigen eine eigene Firebase-Installation.
- Backend: `JWT__Key`, `PmPayment__Salt`, `PmPayment__AGS`, `BereichB__SuperAdminApiKey` beziehungsweise lokale .NET User Secrets setzen. Den CMS-Key passend zu `PAYLOAD_API_KEY` setzen. Produktive Passwörter und Connection Strings immer extern setzen; vorhandene `password`/`123456`-Werte sind ausschließlich lokale Demo-/Testwerte.
- Entwicklungs-Seeder: `SEED_KOMMUNE_RSA_XML` (privater RSA-XML-Schlüssel), `SEED_KOMMUNE_ENCRYPTION_KEY` (32 zufällige Bytes, Base64) und bei Nutzung des Bürger-Seeders `SEED_BUERGER_RSA_XML` extern bereitstellen. Die Kommune-Schlüssel müssen über Neustarts stabil bleiben. Vorhandene verschlüsselte Seed-Daten nicht mit neuen Schlüsseln mischen. Bei fehlenden Werten wird die Verwendung abgebrochen. Tests erzeugen eigene Schlüssel und brauchen diese Konfiguration nicht.
- Container: `CONTAINER_REGISTRY_IMAGE` auf den eigenen Registry-/Projektpfad setzen. Die verbleibenden `example.invalid`-Hosts sind bewusst nicht erreichbar und müssen für eigene Deployments ersetzt werden, einschließlich Keycloak/BundID, Deep Links, Monitoring und Helm.
- iOS: eigene Team-ID im Build setzen, `TEAM_ID`, `MATCH_GIT_URL`, `MATCH_GIT_BRANCH` und `APP_IDENTIFIER` für Fastlane konfigurieren; Apple-App-Site-Association und Android-Fingerprints mit eigenen Signing-Daten bereitstellen.
- Sentry: `VITE_SENTRY_DSN` für Backoffice/Stele, `SENTRY_DSN` für CMS und `Sentry__Dsn` für Backend. Source-Map-Upload verwendet `SENTRY_ORG`, `SENTRY_PROJECT`, optional `SENTRY_URL` sowie den bisherigen `SENTRY_AUTH`. Flutter verwendet weiterhin Dart-Defines.
- Rechtstexte: vor einem produktiven Betrieb die Betreiberinformationen und konkrete Datenschutzerklärung ergänzen.

## Git-Historie und Veröffentlichung

Die vorhandene Historie ist **nicht bereinigt**. Der lokale Signaturscan über alle erreichbaren Objekte untersuchte 9.145 Blob-Versionen aus 1.764 Commits und fand 13 Google-Key-, 8 private-RSA- und 4 Mapbox-Token-Treffer. Diese Zahlen bezeichnen Treffer in Dateiversionen, nicht verschiedene Schlüssel. Autoren-/Commit-Metadaten, Branches und Tags können ebenfalls persönliche Angaben enthalten.

Für einen neuen öffentlichen Import ausschließlich den bereinigten Dateistand **ohne `.git` und ohne alte Branches/Tags** verwenden und im Ziel eine neue Historie beginnen. Kein Mirror-Push und kein Push der bisherigen Branch-Historie. Wenn die Historie erhalten bleiben soll, ist zuerst eine gesonderte History-Bereinigung einschließlich Autoren-/Commit-Metadaten erforderlich. Lokale ignorierte `.env`-, Service-Account-, Signing-, Konfigurations- und Dump-Dateien nicht mitkopieren.

Tatsächlich genutzte entfernte Payment-/CMS-/Mapbox-Zugangsdaten sowie verwendetes privates Seed-Schlüsselmaterial müssen beim Betreiber ersetzt beziehungsweise migriert werden. Firebase-Client-API-Keys und Sentry-DSNs sind keine privaten Server-Schlüssel, wurden aber wegen ihres Projektbezugs ebenfalls entfernt. Der aktive Zustand dieser Zugangsdaten wurde nicht bei externen Diensten abgefragt.

## Wiederholbare Prüfung und Grenzen

`python3 scripts/publication_audit.py` prüft den aktuellen versionierten und nicht ignorierten Dateistand. `python3 scripts/publication_audit.py --history` prüft alle erreichbaren Git-Blobs. Ausgabe enthält ausschließlich Pfade, Zeilen und Kategorien; bei Treffern ist der Exit-Code ungleich null. Dies ist ein gezielter Signaturscan, kein vollständiger Ersatz für einen allgemeinen Secret-Scanner oder eine manuelle Prüfung. Er erfasst nicht beliebige unbekannte Zugangsdaten, jedes Bilddetail, nicht erreichbare Git-Objekte oder externe CI-Variablen/Backups. OCR ist fehleranfällig; alle GIF-Frames wurden nicht manuell geprüft. Eine absolute Geheimnisfreiheit wird nicht behauptet.

## Nachprüfung vor erneutem Import

Die zuvor veröffentlichte Dokumentation enthielt Zugangsdaten zur Nextcloud-Freigabe und zur gehosteten Hackathon-Instanz. Diese Angaben und der Freigabelink wurden aus diesem Dateistand entfernt; die betroffenen Zugangsdaten müssen beim Betreiber gesperrt oder geändert werden. Bestehende Sitzungen bzw. Tokens sind ebenfalls zu widerrufen. Zugangsdaten werden Teilnehmenden ausschließlich separat übermittelt. Die Rotation und die serverseitige Löschung alter Git-Objekte sind durch diese Dateibereinigung nicht nachgewiesen.

Die Zuständigkeitsspalte des Kategorieimports enthält jetzt ausschließlich eine synthetische Beispielzuständigkeit. Development verwendet standardmäßig die mitgelieferten synthetischen LageHelfer-Beispieldaten. `LICENSE.md` und `publiccode.yml` wurden unverändert aus dem bisherigen öffentlichen `main` übernommen.

Die folgende Validierung dokumentiert den früheren Stand vom 2026-11-09 und bestätigt nicht die Vollständigkeit der damaligen Bereinigung.

## Frühere Validierung

- `web-format`: erfolgreich mit der lokal installierten Prettier-Version 3.8.1 (die ausführbare Datei ist im Workspace nicht verlinkt).
- `cms-tests`: 95 Tests in 13 Suiten erfolgreich. Drei weitere Suiten sind durch bestehende Payload-/Zod-Abhängigkeitsfehler blockiert.
- `backoffice-tests`: 37 Tests erfolgreich.
- `backend-tests`: 15 Tests erfolgreich; Backend-Build erfolgreich mit 13 Warnungen in bestehenden Testdateien.
- `dart-format`: erfolgreich.
- `flutter-analyze`: erfolgreich.
- `flutter-test`: erfolgreich.
- `publication-audit`: erfolgreich.
- `diff-check`: erfolgreich.

CMS-Typprüfung (`tsc --noEmit --incremental false`): zwei Fehler in unveränderten Dateien (`geojson.ts`: `z.toJSONSchema`; `payload.config.ts`: fehlendes `@payloadcms/translations/languages/de`). Zwei iKISS-Testsuiten lassen sich wegen der fehlenden Sprachabhängigkeit nicht laden und wurden im gezielten Wiederholungslauf ausgeschlossen; die POI-Upload-Suite ist durch den Zod-Fehler blockiert. Ein kompletter Deployment-/Android-/iOS-Build wurde nicht ausgeführt.
