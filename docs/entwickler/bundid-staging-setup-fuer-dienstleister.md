# BundID auf Staging – Anleitung für den Dienstleister (CI/CD & Infrastruktur)

Diese Anleitung richtet sich an den Dienstleister, der die GitLab-CI/CD-Pipeline und den
Staging-Server betreibt. Ziel: die BundID-Anbindung, die lokal bereits Ende-zu-Ende funktioniert
(MR !276), auch auf Staging zum Laufen zu bringen. Es geht ausschließlich um die
**BundID-Testumgebung (INT)**, nicht um Produktiv-BundID – das reicht für Staging vollständig aus.

Alle Angaben unten (Server-Pfade, laufende Container, nginx-Config) wurden am 24.08.2026 direkt
auf dem Staging-Server geprüft (`ssh staging`), nicht nur aus dem Repo abgeleitet.

## 1. Was macht BundID technisch?

```
BundID (SAML-IdP, https://int.id.bund.de/idp)
   ↕ SAML 2.0 (signiert + verschlüsselt)
Keycloak (neuer Container: Identity Broker + SAML Service Provider + OIDC Provider)
   ↕ OIDC (App ↔ Keycloak)
Flutter-App / Backend (bestehend, unverändert erreichbar)
```

Es kommt **ein neuer Container** (`keycloak`, plus eine eigene kleine Postgres-DB dafür) zum
bestehenden Stack dazu. App und Backend sprechen nicht direkt mit BundID, sondern nur mit
Keycloak – Keycloak übernimmt die komplette SAML-Kommunikation.

## 2. Ist-Zustand auf Staging (geprüft)

- Deployt wird `docker/docker-compose.yml` aus dem Repo, ausgerollt vom CI-Job
  `deployment:start` (`ci/deployment.gitlab-ci.yml`) nach `/home/deploy_user/deployment/` auf dem
  Server. Images kommen aus `gitlab.example.invalid:5050/hameln-pyrmont/kommunal-app/*`.
- nginx läuft als eigener Container (`hameln-reverse-proxy`), die Config liegt als Bind-Mount
  unter `${MOUNT_POINT}/reverse-proxy.config` – aktuell aufgelöst zu
  `/srv/lk-app-staging/reverse-proxy.config`. `deployment:start` rendert und kopiert diese Datei
  per `scp`; der Pipeline-User **`deploy_user`** muss dafür in der Server-Gruppe
  **`lk-hameln-pyrmont`** sein (Schreibrecht auf `${MOUNT_POINT}`).
- TLS läuft über einen `certbot`-Container im selben Compose-Stack (Let's-Encrypt-Zertifikate,
  automatisches Renewal alle 12h). Für eine neue Subdomain gibt es bereits ein funktionierendes
  Vorbild: `stele.example.invalid` (eigener `server{}`-Block, eigenes Zertifikat,
  Proxy auf einen internen Container).
- **Was aktuell fehlt:** kein `keycloak`-Service im Compose-File, kein Docker-Image dafür in der
  Registry, kein DNS-Eintrag für `auth.example.invalid`, kein nginx-Routing dafür.

## 3. Schritte für den Dienstleister

### Schritt 1 – Keycloak-Image bauen und pushen

Ein Dockerfile existiert bereits im Repo: `docker/keycloak/Dockerfile`. Es enthält **keine
Geheimnisse** – nur `FROM quay.io/keycloak/keycloak:26.6.3` plus zwei Health/Metrics-Env-Vars –
kann also bedenkenlos wie jedes andere Image gebaut und in die Registry gepusht werden.

Neuer CI-Job nach dem Vorbild der bestehenden `push:backend` / `push:stele` Jobs (siehe
`ci/components/backend.gitlab-ci.yml:112` bzw. `ci/components/stele.gitlab-ci.yml:50`): baut
`docker/keycloak/Dockerfile` und pusht nach
`gitlab.example.invalid:5050/hameln-pyrmont/kommunal-app/keycloak:<tag>`.

### Schritt 2 – Zwei neue Services im `docker-compose.yml`

Analog zu `docker/docker-compose.local.yml` (dort bereits vollständig durchgetestet), aber:
- `image: .../keycloak:<tag>` statt `build:` (Image kommt aus der Registry wie alle anderen).
- **Keine Ports nach außen veröffentlichen** – Keycloak wird nur intern im
  `hameln-pyrmont`-Netzwerk unter dem Servicenamen `keycloak` angesprochen, genau wie
  `backend`/`bereich-a`/`stele` das auch schon tun. nginx übernimmt die Außensicht.
- Env-Variablen 1:1 wie lokal: `KC_HOSTNAME=auth.example.invalid`,
  `KC_HOSTNAME_STRICT=false`, `KC_PROXY_HEADERS=xforwarded`, sowie die beiden
  `KC_SPI_SAML_AUTHENTICATION_PREPROCESSOR_BUNDID_PROTOCOL_*_AUTHN_METHODS`-Variablen (schränken
  BundID bewusst auf Benutzername/Passwort ein – ohne beide Werte böte BundID zusätzlich
  eID/eIDAS/ELSTER etc. an, siehe Kommentar in `docker-compose.local.yml`).
- `keycloak-db`: eigener `postgres:15-alpine`-Container mit eigenem Volume, exakt wie lokal.
- `docker/keycloak/realm-kommunalapp.json` (Teil des Repos, kein Geheimnis) wird beim Start per
  `start-dev --import-realm` eingelesen.

### Schritt 3 – Geheimnisse einmalig auf den Server bringen (NICHT über Git/CI)

Die eigentlichen Zertifikate/Schlüssel dürfen **nie** durch die Pipeline oder als Git-Commit
laufen (private Schlüssel!). Ich stelle sie separat, außerhalb von GitLab, bereit
(`~/Downloads/BundID-Secrets-fuer-DevSecOps/`, mit `PASSWOERTER_UND_HINWEISE.txt`, die jede Datei
erklärt). Inhalt kurz:

- Extension-JAR (`keycloak-extension-bundid-status-detail.jar`) – liefert die BundID-spezifischen
  SAML-Mapper.
- Unser eigenes SP-Signing-/Encryption-Zertifikat+Schlüssel (`bundid-saml-signing.{crt,p12}`,
  `bundid-saml-encryption.{crt,p12}`) plus Keystore-Passwort.
- BundIDs eigenes INT-Signing-Zertifikat (`bundid-int-idp-signing.crt`) – ohne diese Datei
  schlägt jeder Login mit `Invalid signature on document` fehl.

Auf dem Server ablegen unter `${MOUNT_POINT}/bundid-secrets/keycloak/` (aktuell also
`/srv/lk-app-staging/bundid-secrets/keycloak/`, neben dem bereits vorhandenen
`reverse-proxy.config`/`certbot`), als **read-only Bind-Mount** im `keycloak`-Service eintragen –
genau wie lokal in `docker-compose.local.yml`.

### Schritt 4 – DNS

A-Record `auth.example.invalid` → Staging-Server-IP (dieselbe IP wie
`app.example.invalid`). Dieser Hostname ist bei BundID fest registriert (SAML Entity-ID,
siehe `entityId` in `realm-kommunalapp.json`) – bitte nicht eigenmächtig ändern, sonst muss bei
BundID/AKDB neu registriert werden.

### Schritt 5 – nginx-Routing + TLS-Zertifikat

Neuer `server{}`-Block nach dem Vorbild des bestehenden Stele-Blocks in
`/srv/lk-app-staging/reverse-proxy.config` (`server_name stele.example.invalid`):

- `server_name auth.example.invalid;`
- `proxy_pass http://keycloak:8080;` plus die üblichen `X-Forwarded-*`-Header (Keycloak erwartet
  das über `KC_PROXY_HEADERS: xforwarded`).
- Ausreichend große Proxy-Buffer für SAML-POST-Bindings (`proxy_buffer_size`,
  `proxy_buffers`) – SAML-Assertions können mehrere KB groß werden, Standard-nginx-Buffer reichen
  dafür oft nicht.
- Zertifikat wie gewohnt per certbot beantragen (derselbe Prozess wie für
  `stele.example.invalid`), plus den üblichen 80→443-Redirect-Block nicht vergessen.

### Schritt 6 – Einmalige Keycloak-Konfiguration nach dem ersten Start

Nach dem ersten erfolgreichen Start des neuen `keycloak`-Service müssen drei Skripte aus
`scripts/bundid/` einmalig **gegen die neue Staging-Instanz** laufen
(`KEYCLOAK_ADMIN_PASSWORD=... ./scripts/bundid/configure-bundid-idp.sh`, danach
`configure-bundid-keys.sh` mit zusätzlich `BUNDID_KEYSTORE_PASSWORD=...`, danach
`configure-bundid-flow.sh`). Das übernehme ich gerne selbst, sofern kurzzeitig Zugriff auf die
Keycloak-Admin-API besteht (z.B. per SSH-Tunnel) – braucht keine dauerhafte Berechtigung. Wichtig:
diese drei Schritte müssen nach jedem Volume-Reset der `keycloak-db` erneut ausgeführt werden.

### Schritt 7 – Backend-/App-Konfiguration (keine Dienstleister-Aufgabe, zur Vollständigkeit)

- Backend: `BundId:KeycloakAuthority` in der Staging-`.dotnet_env`
  (GitLab-CI/CD-Variable `DOTNET_ENV_FILE`) auf
  `https://auth.example.invalid/realms/kommunalapp` setzen.
- App: die GitLab-CI/CD-Datei-Variable `$APP_ENV_FILE` (Pendant zum lokalen
  `app/environments/config-development.json`, siehe `ci/components/app.gitlab-ci.yml`) um
  `BUNDID_CLIENT_ID`/`BUNDID_OIDC_ISSUER`/`BUNDID_REDIRECT_URL`/`BUNDID_IDP_HINT` ergänzen.

Diese beiden Punkte mache ich selbst, kein Handlungsbedarf beim Dienstleister – nur zur Einordnung,
warum ein Login trotz fertiger Infrastruktur noch nicht sofort funktioniert.

### Schritt 8 – Testen

Staging-App-Build → „Mit BundID anmelden" → Browser-Redirect zu `int.id.bund.de` → Rücksprung zu
`https://auth.example.invalid/...` → App meldet an.

## 4. Verantwortlichkeiten auf einen Blick

| Aufgabe | Wer |
|---|---|
| CI-Job: Keycloak-Image bauen & pushen | Dienstleister |
| `docker-compose.yml`: `keycloak` + `keycloak-db` ergänzen | Dienstleister |
| DNS-Eintrag `auth.example.invalid` | Dienstleister |
| nginx-Block + TLS-Zertifikat | Dienstleister |
| Secrets-Ordner als Bind-Mount einbinden (Pfad/Rechte) | Dienstleister |
| Zertifikate/Schlüssel/Passwörter selbst bereitstellen | Betreiber |
| Einmalige Keycloak-Konfiguration (3 Skripte) | Betreiber, ggf. mit kurzem Zugriff |
| Backend-/App-Konfiguration für Staging | Betreiber |

## 5. Bekannte Stolperfallen (aus der lokalen Erfahrung)

- Das Feld `signingCertificate` im IdP muss **BundIDs eigenes** Zertifikat enthalten, nicht unser
  eigenes SP-Zertifikat – sonst `Invalid signature on document`, obwohl alle Skripte fehlerfrei
  durchlaufen.
- Ohne `configure-bundid-keys.sh` signiert Keycloak mit einem automatisch generierten, bei BundID
  nicht registrierten Schlüssel – der Login schlägt dann ohne aussagekräftigen Fehler fehl.
- Ohne `configure-bundid-flow.sh` zeigt Keycloak nach erfolgreichem Login eine eigene
  Zwischenseite („Update Account Information") statt direkt zur App zurückzuspringen.
- Der Realm zeigt aktuell ausschließlich auf BundID **INT** – für Staging genau richtig. Eine
  spätere Produktivsetzung braucht eine eigene PROD-Realm-/IdP-Strategie, die noch nicht
  entschieden ist (siehe `docs/entwickler/bundid.adoc`, Abschnitt „Bekannte Einschränkungen").

Ausführlichere Hintergründe (alle gefundenen Bugs, vollständige lokale Setup-Reihenfolge,
Zertifikats-Details) stehen in `docs/entwickler/bundid.adoc`.
