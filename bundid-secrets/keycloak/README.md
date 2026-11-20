# bundid-secrets/keycloak/

Dieses Verzeichnis ist bis auf diese README per `.gitignore` komplett von Git ausgeschlossen
(`bundid-secrets/*` + gezielte Ausnahme). Hier legst du die lokal bereits vorhandenen,
für die BundID-INT-Anbindung benötigten Artefakte ab, die von `docker-compose.local.yml` und
`scripts/bundid/configure-bundid-idp.sh` erwartet werden:

| Datei | Zweck |
|---|---|
| `keycloak-extension-bundid-status-detail.jar` | lokal korrigiertes Keycloak-Extension-JAR (BundID-Provider), wird per Bind-Mount in den `keycloak`-Container eingehängt |
| `bundid-int-idp-signing.crt` | **BundIDs eigenes** Signing-Zertifikat der INT-Umgebung (PEM, `CN=idp.akdb.de`), verifiziert die von BundID signierten SAML-Responses – öffentlich, kein Secret, aber nicht Teil des Repos und nicht per Selbstsignatur erzeugbar |
| `bundid-saml-signing.crt` | öffentliches Signing-Zertifikat des SP – nur für die Realm-Keys (`configure-bundid-keys.sh`), NICHT für `signingCertificate` des IdP |
| `bundid-saml-signing.key` | privater Signing-Schlüssel (RSA 4096, PEM) – nur lokal, nie einchecken |
| `bundid-saml-encryption.crt` | öffentliches Encryption-Zertifikat des SP (PEM) |
| `bundid-saml-encryption.key` | privater Encryption-Schlüssel (RSA 4096, PEM) – nur lokal, nie einchecken |

**Nicht verwechseln:** `bundid-int-idp-signing.crt` (BundIDs Zertifikat) und `bundid-saml-signing.crt`
(unser eigenes SP-Zertifikat) landen in zwei unterschiedlichen Feldern der Keycloak-IdP-Config
(`signingCertificate` vs. Realm-Key-Provider). Vertauscht schlägt jede BundID-Anmeldung mit
"Invalid signature on document" fehl, obwohl beide Setup-Skripte fehlerfrei durchlaufen.

Die Dateien einfach aus dem vorherigen lokalen Setup hierher kopieren. Vor jedem Commit prüfen,
dass hier nichts versehentlich getrackt wird:

```bash
git status --short bundid-secrets/
git check-ignore -v bundid-secrets/keycloak/*.jar bundid-secrets/keycloak/*.key bundid-secrets/keycloak/*.crt
```
