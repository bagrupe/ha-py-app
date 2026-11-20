# BundID auf Staging – manuelle Checkliste

Diese Liste sammelt alles, was **nicht** vollständig über Git/CI läuft und vor bzw. nach
dem ersten Keycloak-Deploy auf Staging erledigt werden muss. Die automatischen Schritte
(Compose-Services, Image-Build inkl. BundID-Configure-Skripte, automatischer Lauf beim
Keycloak-Container-Start) kommen mit dem Implementierungs-MR ins Repo — diese Datei ist deine
persönliche Erinnerung für den Rest.

**Ziel:** BundID-Login auf Staging (`int.id.bund.de` → Keycloak → App/Backend).

**Hostname (fest bei BundID registriert, nicht ändern):** `auth.example.invalid`

---

## Kurzüberblick: Was läuft automatisch vs. manuell

| Schritt | Wer / wie |
|---|---|
| Keycloak-Image bauen & pushen (`backend-*`-Tag) | CI |
| `keycloak` + `keycloak-db` in `docker-compose.yml` | CI / Repo |
| Realm-JSON, Themes auf Server kopieren | CI (`deployment:start`) |
| Configure-Skripte (`scripts/bundid/`) | Im Keycloak-Image, laufen beim Container-Start |
| Zertifikate, JAR, `.p12`-Keystores auf Server | **Du (manuell)** |
| GitLab CI-Variablen (`DEPLOYMENT_ENV_FILE`, …) | **Du (manuell)** |
| DNS | **Du** (laut dir bereits erledigt) |
| nginx-Config (`reverse-proxy.config`) rendern & auf Server kopieren | CI (`deployment:start`, Abschnitt 4; `deploy_user` ∈ Gruppe `lk-hameln-pyrmont`) |
| Let's-Encrypt-Zertifikat für Auth-Subdomain | **Du (certbot, siehe unten)** |
| Erster End-to-End-Test | **Du** |

---

## 1. BundID-Secrets auf den Server legen

### Warum?

Keycloak braucht SAML-Zertifikate und ein Extension-Plugin, die **bewusst nicht** im Git-Repo
liegen (private Schlüssel, externes JAR). Der Container mountet sie read-only vom Server.

### Wo?

Auf dem Staging-Server, neben der bestehenden Infrastruktur:

```text
${MOUNT_POINT}/bundid-secrets/keycloak/
```

Aktuell typischerweise: `/srv/lk-app-staging/bundid-secrets/keycloak/`
(`MOUNT_POINT` steht in der GitLab-Variable `DEPLOYMENT_ENV_FILE`).

### Was muss in dem Ordner liegen?

| Datei | Geheim? | Warum nötig |
|---|---|---|
| `keycloak-extension-bundid-status-detail.jar` | Nein (Binary) | Keycloak-Plugin für BundID-SAML; ohne JAR startet Keycloak, aber BundID-Login funktioniert nicht |
| `bundid-int-idp-signing.crt` | Nein (öffentlich) | BundIDs INT-Signing-Zertifikat; verifiziert deren SAML-Antworten. Fehlt oder falsch → `Invalid signature on document` |
| `bundid-saml-signing.p12` | **Ja** | Unser SP-Signing-Keystore (bei BundID registriert) |
| `bundid-saml-encryption.p12` | **Ja** | Unser SP-Encryption-Keystore |
| `bundid-saml-encryption.crt` | Nein | Wird von `configure-bundid-idp.sh` gelesen |

Optional lokal, auf Staging für die Skripte nicht zwingend: `.key`/`.crt`-PEM-Dateien
(siehe `bundid-secrets/keycloak/README.md`).

### Woher bekommst du die Dateien?

Nicht aus dem Repo — nur die README liegt versioniert vor. Beschaffung:

- Ordner `bundid-secrets/keycloak/` vom verantwortlichen Betreiber
- oder Paket `BundID-Secrets-fuer-DevSecOps` (laut `docs/entwickler/bundid.adoc`)

### Rechte prüfen

```bash
# Als deploy_user auf dem Staging-Server
ls -la /srv/lk-app-staging/bundid-secrets/keycloak/
# Docker muss die Dateien lesen können (typisch: lesbar für den Container-User)
```

---

## 2. GitLab CI/CD-Variablen pflegen

### Warum?

Passwörter und App-/Backend-Konfiguration kommen über geschützte GitLab File-Variablen in
den Deploy — nicht ins Repo.

### `DEPLOYMENT_ENV_FILE` (Staging-Umgebung)

Ergänzen bzw. prüfen (Vorlage im Repo: `.env.keycloak.example`):

```dotenv
# Keycloak-Datenbank (eigener Postgres-Container keycloak-db)
KEYCLOAK_DB_USER=keycloak
KEYCLOAK_DB_PASSWORD=<starkes Passwort>
KEYCLOAK_DB_NAME=keycloak

# Keycloak Admin (für Configure-Skripte + Admin-Konsole)
KEYCLOAK_ADMIN_USER=admin
KEYCLOAK_ADMIN_PASSWORD=<starkes Passwort>

# Passwort für beide .p12-Keystores (gleiches Passwort für signing + encryption)
BUNDID_KEYSTORE_PASSWORD=<aus Secrets-Paket>

# Von BundID vorgeschriebener Anzeigename (muss zum BundID-Registrierungseintrag passen)
BUNDID_ORGANIZATION_DISPLAY_NAME=KommunalApp Hameln-Pyrmont

# Bereits vorhanden — Pfad auf dem Server für Bind-Mounts (nginx, certbot, bundid-secrets)
MOUNT_POINT=/srv/lk-app-staging

# Nginx-Hostnamen (Vorlage: .env.nginx.example)
APP_DOMAIN=app.example.invalid
STELE_DOMAIN=stele.example.invalid
```

### `DOTNET_ENV_FILE` (Staging-Umgebung)

Backend muss Keycloak als OIDC-Issuer kennen (`backend` liest `.dotnet_env`):

```dotenv
BundId__Enabled:true
BundId__KeycloakAuthority:https://auth.example.invalid/realms/kommunalapp
BundId__Audience:kommunalapp-mobile
BundId__IdentityProviderAlias:bundid
```

Vorlage im Repo: `.env.backend.example`

### `APP_ENV_FILE` (Staging-Umgebung)

Flutter-App braucht OIDC-Parameter für „Mit BundID anmelden“ (werden beim App-Build
eingebaut):

```json
{
  "BUNDID_CLIENT_ID": "kommunalapp-mobile",
  "BUNDID_OIDC_ISSUER": "https://auth.example.invalid/realms/kommunalapp",
  "BUNDID_REDIRECT_URL": "de.landkreis.hapy.app.staging:/oauthredirect",
  "BUNDID_IDP_HINT": "bundid"
}
```

**Hinweis:** Staging-Bundle-ID ist `de.landkreis.hapy.app.staging` (siehe
`app/android/app/build.gradle`, Flavor `staging`). Der Keycloak-Client im Realm muss diese
Redirect-URI erlauben — das sollte im Implementierungs-MR in `realm-kommunalapp.json`
ergänzt werden. Falls der Login mit „Invalid redirect URI“ scheitert, fehlt vermutlich
genau dieser Eintrag.

---

## 3. DNS

### Warum?

BundID und die App leiten den Browser auf `https://auth.example.invalid` um.
Ohne DNS landet der Redirect ins Leere.

### Was prüfen?

```bash
dig +short auth.example.invalid
# → IP des Staging-Servers (gleiche wie app.example.invalid)
```

Laut deiner Rückmeldung: **bereits erledigt.**

---

## 4. nginx-Reverse-Proxy (Keycloak-Routing)

### Warum?

Keycloak hat **keinen** öffentlichen Host-Port. Der Reverse-Proxy (`hameln-reverse-proxy`)
terminiert TLS und leitet intern an `http://keycloak:8080` weiter. SAML-POST-Bindings
brauchen großzügige Proxy-Buffer.

Die öffentliche Config liegt **nicht** im Deploy-Ordner `~/deployment/`, sondern als Bind-Mount
unter `${MOUNT_POINT}/reverse-proxy.config` (z. B. `/srv/lk-app-staging/reverse-proxy.config`).

### Automatisch bei `deployment:start`

Bei jedem Staging-/PreProd-/Production-Deploy (`ci/deployment.gitlab-ci.yml`, Job `deployment:start`):

1. GitLab-Variable `DEPLOYMENT_ENV_FILE` wird zu `.env` zusammengeführt (u. a. `MOUNT_POINT`,
   `APP_DOMAIN`, `STELE_DOMAIN`; optional `KEYCLOAK_HOSTNAME`, Standard
   `auth.example.invalid` — siehe `.env.nginx.example`).
2. `.gitlab/scripts/render_reverse_proxy.sh` rendert `docker/nginx/reverse-proxy.conf.template`
   → `reverse-proxy.config`.
3. Die Datei wird per `scp` auf den Server nach `${MOUNT_POINT}/reverse-proxy.config` kopiert
   (vor `docker compose up`).
4. `docker compose … up -d --force-recreate` startet den Proxy neu; er liest die aktuelle
   Config vom Host-Mount.

**Voraussetzung:** `MOUNT_POINT` und die Nginx-Hostnamen müssen in der GitLab-`DEPLOYMENT_ENV_FILE`
für die Zielumgebung gesetzt sein (Schritt 2 oben).

**Server-Berechtigungen:** Der SSH-Benutzer der Pipeline (`deploy_user`, siehe `ci/deployment.gitlab-ci.yml`)
muss auf dem Zielserver Mitglied der Unix-Gruppe **`lk-hameln-pyrmont`** sein. Nur so kann
`deployment:start` unter `${MOUNT_POINT}` (z. B. `/srv/lk-app-staging/`) die Datei
`reverse-proxy.config` anlegen und überschreiben. Fehlt die Gruppenzugehörigkeit, schlägt der
`scp`-Schritt mit „Permission denied“ fehl.

### Manuell nur bei Sonderfällen

- **Erstes Zertifikat / nur HTTP-Phase:** siehe Abschnitt 5 — ggf. temporär vereinfachte Config
  auf dem Server anpassen, certbot ausführen, danach reguläres `deployment:start`.
- **Hotfix ohne vollen Deploy:** Config auf dem Server bearbeiten und nginx prüfen/neu laden:

  ```bash
  ssh deploy_user@<staging-ip>
  cd /home/deploy_user/deployment
  docker compose -f docker-compose.yml -p hameln-pyrmont --env-file ./.env exec proxy nginx -t
  docker compose -f docker-compose.yml -p hameln-pyrmont --env-file ./.env exec proxy nginx -s reload
  ```

  (`--env-file ./.env` nur, wenn die Datei auf dem Server noch existiert; nach Deploy wird sie
  aus Sicherheitsgründen wieder gelöscht.)

### Prüfen

```bash
ssh deploy_user@<staging-ip>
grep -E 'server_name|keycloak' /srv/lk-app-staging/reverse-proxy.config
docker compose -f /home/deploy_user/deployment/docker-compose.yml -p hameln-pyrmont ps proxy
```

---

## 5. TLS-Zertifikat (certbot) — empfohlene Reihenfolge

### Warum?

Der HTTPS-`server{}`-Block verweist auf Let's-Encrypt-Dateien unter
`/etc/letsencrypt/live/auth.example.invalid/`. Existieren die noch nicht,
startet nginx mit SSL-Block ggf. **nicht** — das betrifft den ganzen Proxy-Stack.

### Empfehlung (zweistufig, wie bei `stele.example.invalid`)

**Phase A — Zertifikat beantragen (nur HTTP nötig)**

1. Secrets auf Server legen (Schritt 1).
2. GitLab-Variablen setzen (Schritt 2).
3. nginx-Config mit mindestens dem **Port-80-Block** für
   `auth.example.invalid` deployen (ACME-Challenge unter
   `/.well-known/acme-challenge/`).
4. Stack starten / nginx reloaden — Proxy muss auf Port 80 erreichbar sein.
5. Zertifikat beantragen:

   ```bash
   ssh deploy_user@<staging-ip>
   cd /home/deploy_user/deployment

   docker compose -f docker-compose.yml -p hameln-pyrmont run --rm certbot certonly \
     --webroot -w /var/www/certbot \
     -d auth.example.invalid \
     --email <deine-admin-mail> \
     --agree-tos \
     --no-eff-email
   ```

   (`certbot`-Container und Webroot-Volumes sind bereits im Compose-Stack verdrahtet.)

**Phase B — HTTPS aktivieren**

6. Reguläres `deployment:start` ausführen — rendert die vollständige Config inkl. HTTPS-`server{}`
   (Port 443 + `ssl_certificate`-Pfade) aus `docker/nginx/reverse-proxy.conf.template` und kopiert sie
   nach `${MOUNT_POINT}/reverse-proxy.config` (Abschnitt 4).
7. Proxy-Container startet mit der neuen Config neu; bei Bedarf manuell `nginx -t` / `nginx -s reload`
   (siehe Abschnitt 4).
8. Renewal läuft automatisch über den `certbot`-Container (alle 12h).

### Alternative (wenn MR bereits vollen HTTPS-Block enthält)

Erst **nur** den HTTP-Block (Port 80) manuell einfügen → certbot → danach HTTPS-Block
nachziehen. Nicht beides gleichzeitig aktivieren, solange das Zertifikat fehlt.

### Prüfen

```bash
curl -I https://auth.example.invalid/
# Erwartung: HTTP-Antwort von Keycloak (z. B. 302 oder 200), kein Zertifikatsfehler
```

---

## 6. Deployment auslösen

### Warum?

Erst jetzt sind Voraussetzungen erfüllt: Secrets auf dem Server, CI-Variablen, DNS, nginx
(mindestens HTTP).

### Was tun?

1. `backend-*`-Release-Tag pushen (wie bei jedem Backend-Staging-Deploy).
2. Pipeline abwarten: `package:keycloak` → `push:keycloak` → `deployment:start`.
3. Auf dem Server prüfen:

   ```bash
   docker compose -f docker-compose.yml -p hameln-pyrmont ps
   # hameln-keycloak + hameln-keycloak-db sollten „running“ / healthy sein
   ```

4. BundID-Configure-Skripte laufen **im Keycloak-Container** beim Start (idempotent). Logs prüfen:

   ```bash
   docker logs hameln-keycloak 2>&1 | tail -50
   # Erwartung: „BundID configure scripts completed.“ oder Hinweis, dass Secrets fehlen
   ```

   Manueller Fallback: Abschnitt 8.

---

## 7. End-to-End testen

### Warum?

Viele Fehler zeigen sich erst im echten Browser-Flow (SAML-Redirect, Zertifikate, Redirect-URI).

### Ablauf

1. Staging-App-Build mit aktualisiertem `APP_ENV_FILE` installieren.
2. In der App: **„Mit BundID anmelden“**.
3. Erwarteter Flow:
   - Redirect zu `https://int.id.bund.de/...`
   - Login mit BundID-Testuser (INT)
   - Rücksprung zu `https://auth.example.invalid/...`
   - App meldet angemeldet an

### Typische Fehler

| Symptom | Wahrscheinliche Ursache |
|---|---|
| `Invalid signature on document` | Falsches Zertifikat in IdP-Config (`bundid-int-idp-signing.crt` fehlt/falsch) |
| Login bricht ohne Fehlermeldung ab | SP-Keys nicht gesetzt (`.p12` fehlt oder `BUNDID_KEYSTORE_PASSWORD` falsch) |
| Keycloak-Zwischenseite „Update Account Information“ | `configure-bundid-flow.sh` nicht gelaufen |
| `Invalid redirect URI` | Staging-Bundle-ID fehlt in Keycloak-Client `redirectUris` |
| TLS-Fehler auf Auth-Hostname | certbot noch nicht gelaufen oder nginx-SSL-Block zu früh aktiv |
| 502 von nginx | Keycloak-Container nicht gestartet oder nicht im `hameln-pyrmont`-Netzwerk |

Ausführlichere Fehleranalyse: `docs/entwickler/bundid.adoc`

---

## 8. Manueller Fallback: Configure-Skripte

### Warum?

Falls die Skripte beim Container-Start fehlgeschlagen sind (Secrets erst später gelegt, falsches
Passwort, Keycloak noch nicht bereit), kannst du sie im laufenden Container nachholen.

### Auf dem Server (nach SSH)

```bash
docker exec -it hameln-keycloak bash -c '
  export KEYCLOAK_URL=http://localhost:8080
  export BUNDID_SECRETS_DIR=/opt/keycloak/bundid-secrets
  bash /opt/keycloak/bundid-config/configure-bundid-idp.sh
  bash /opt/keycloak/bundid-config/configure-bundid-keys.sh
  bash /opt/keycloak/bundid-config/configure-bundid-flow.sh
'
```

Alternativ den Container neu starten (Skripte laufen bei jedem Start erneut):

```bash
cd /home/deploy_user/deployment
docker compose -f docker-compose.yml -p hameln-pyrmont --env-file ./.env restart keycloak
```

Die Skripte sind **idempotent** — mehrfaches Ausführen ist unkritisch.

**Wann erneut nötig?** Nach einem **Volume-Reset** von `keycloak-db` (leere DB → Realm wird
neu importiert, IdP-Keys/Flow müssen wieder eingespielt werden).

---

## 9. Nach dem ersten erfolgreichen Deploy

- [ ] Secrets-Ordner vollständig und lesbar
- [ ] GitLab-Variablen für Staging gesetzt (`DEPLOYMENT_ENV_FILE`, `DOTNET_ENV_FILE`, `APP_ENV_FILE`)
- [ ] DNS zeigt auf Staging-Server
- [ ] `DEPLOYMENT_ENV_FILE` enthält `MOUNT_POINT`, `APP_DOMAIN`, `STELE_DOMAIN` (nginx via `deployment:start`)
- [ ] `deploy_user` ist Mitglied von `lk-hameln-pyrmont` (Schreibzugriff auf `${MOUNT_POINT}`)
- [ ] `reverse-proxy.config` auf Server enthält Auth-Hostname (`KEYCLOAK_HOSTNAME`)
- [ ] Let's-Encrypt-Zertifikat für `auth.example.invalid`
- [ ] `hameln-keycloak` + `hameln-keycloak-db` laufen
- [ ] `https://auth.example.invalid/` erreichbar
- [ ] BundID-Login in Staging-App getestet

---

## Referenzen im Repo

- Lokales Referenz-Setup: `docker/docker-compose.local.yml`
- Secrets-Erwartungen: `bundid-secrets/keycloak/README.md`
- Ausführliche Technik-Doku: `docs/entwickler/bundid.adoc`
- Ursprüngliche Dienstleister-Anleitung: `docs/entwickler/bundid-staging-setup-fuer-dienstleister.md`
