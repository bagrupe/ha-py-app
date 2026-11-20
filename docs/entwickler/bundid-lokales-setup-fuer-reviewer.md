# BundID lokal testen – Kurzanleitung für Reviewer

Diese Anleitung deckt nur das ab, was zusätzlich zum normalen Projekt-Setup (siehe
Haupt-README, Abschnitt "Quick Start Guide") für die BundID-Anbindung nötig ist. Alle Schritte
sind einmalig, danach reicht `docker compose ... up -d` + `task backend` + `task app:dev`.

## 1. Voraussetzungen

- Normales Projekt-Setup bereits erledigt (Docker, .NET 8 SDK, `fvm`/Flutter, `task`-CLI,
  `app/environments/config-development.json` vorhanden).
- Den Secrets-Ordner `keycloak/` (nicht `keycloak-prod/`, den braucht ihr nicht) von mir erhalten.
  Kopiert ihn nach `bundid-secrets/keycloak/` im Projekt-Root (also
  `bundid-secrets/keycloak/bundid-saml-signing.p12` usw.) – der Ordner ist per `.gitignore`
  bewusst nicht Teil des Repos.
- Das Klartext-Passwort für die beiden `.p12`-Keystores (liegt als Textdatei bei den Secrets,
  gilt für beide Dateien gleichermaßen). Meldet euch bei mir, falls es fehlt.

## 2. Infrastruktur starten

```bash
docker compose -f docker/docker-compose.local.yml -p hameln up -d
```

Kurz warten, bis der `hameln-keycloak`-Container läuft (`docker compose -f
docker/docker-compose.local.yml -p hameln ps`).

## 3. BundID-Zertifikate in den Identity-Provider einspielen

```bash
KEYCLOAK_ADMIN_PASSWORD=admin ./scripts/bundid/configure-bundid-idp.sh
```

Das trägt zwei **unterschiedliche** Zertifikate in den bereits per Realm-Import angelegten IdP
"bundid" ein – beide müssen als Dateien in `bundid-secrets/keycloak/` liegen (Teil des
Secrets-Ordners, den ihr von mir erhaltet):

- `bundid-int-idp-signing.crt` – **BundIDs eigenes** Signing-Zertifikat (verifiziert die von
  BundID signierten Antworten). Fehlt diese Datei oder ist sie veraltet, schlägt der Login mit
  `Invalid signature on document` fehl, obwohl das Skript fehlerfrei durchläuft.
- `bundid-saml-encryption.crt` – unser eigenes Encryption-Zertifikat.

## 4. Eigene SP-Schlüssel als Realm-Keys hinterlegen

Ohne diesen Schritt signiert Keycloak mit einem automatisch generierten Schlüssel, der bei
BundID nicht registriert ist – der Login schlägt dann fehl.

```bash
KEYCLOAK_ADMIN_PASSWORD=admin BUNDID_KEYSTORE_PASSWORD=<erhaltenes Passwort> \
  ./scripts/bundid/configure-bundid-keys.sh
```

Legt die beiden Realm-Keys `bundid-saml-signing` (RS256) und `bundid-saml-encryption`
(RSA-OAEP, priorisiert über den automatisch generierten Schlüsseln) an bzw. aktualisiert sie,
falls sie schon existieren – kann also gefahrlos mehrfach laufen.

## 5. Keycloaks eigene "Review Profile"-Zwischenseite deaktivieren

Ohne diesen Schritt landet ihr nach einem *erfolgreichen* BundID-Login nicht direkt wieder in
der App, sondern auf Keycloaks eigener "Update Account Information"-Seite – sieht im ersten
Moment wie ein weiterer Fehler aus, ist aber nur ein fehlender Konfigurationsschritt:

```bash
KEYCLOAK_ADMIN_PASSWORD=admin ./scripts/bundid/configure-bundid-flow.sh
```

Idempotent, kann gefahrlos mehrfach laufen.

## 6. Hostname + lokaler HTTPS-Proxy

BundID leitet den Browser nach dem Login auf `https://auth.example.invalid/...`
zurück (fest bei BundID registrierte Adresse, siehe `entityId` im IdP). Dieser Hostname zeigt
öffentlich aktuell auf mein System – das ist nur mein persönlicher Workaround und für euch
irrelevant. Ihr braucht stattdessen **lokal bei euch** eine Umleitung auf euer eigenes
Keycloak:

**a) `/etc/hosts` (mit `sudo` editieren):**

```
127.0.0.1 auth.example.invalid
```

**b) Lokalen HTTPS-Reverse-Proxy auf Port 443, der an Keycloak (Port 8081) weiterleitet.**
Der Hostname erwartet HTTPS ohne Portangabe, ein bloßer `/etc/hosts`-Eintrag reicht daher nicht.
Am einfachsten mit [Caddy](https://caddyserver.com) und dessen lokaler (nicht öffentlicher)
Zertifikatsausstellung:

```bash
brew install caddy
```

Eigene, lokale `Caddyfile` anlegen (**nicht** die im Repo unter `docker/keycloak/Caddyfile` –
die ist für meinen öffentlichen Workaround mit echtem Let's-Encrypt-Zertifikat gedacht):

```
auth.example.invalid {
    tls internal
    reverse_proxy localhost:8081
}
```

```bash
sudo caddy trust                        # einmalig: lokale Caddy-Root-CA im Schlüsselbund vertrauen
sudo caddy run --config ./Caddyfile      # muss laufen, während ihr testet
```

Ohne `caddy trust` zeigt der In-App-Browser beim BundID-Redirect eine Zertifikatswarnung.

## 7. Backend und App starten

```bash
task backend
task app:dev
```

## 8. Testen

In der App: **Ehrenamt-Tab → "Mit BundID anmelden"** bzw. **"Mit BundID registrieren"**, oder
**Profil → Mein Konto → "Mit BundID anmelden"**. Meldet euch bei mir, falls ihr noch keine
BundID-Test-Zugangsdaten (int.id.bund.de) habt.

**Stand 2026-08-11:** Die Schritte 3 und 5 wurden gerade erst korrigiert bzw. ergänzt (fehlendes
Zertifikat, fehlender Skript-Aufruf), nachdem ein Login-Versuch mit der vorherigen Version daran
gescheitert war. Der Fix ist gegen die ursprüngliche Keycloak-Instanz konfigurationsseitig
verifiziert, aber noch nicht durch einen tatsächlich abgeschlossenen Login mit dieser Anleitung
bestätigt worden. Bitte kurz zurückmelden, ob es damit durchläuft oder wo es noch hakt.

---

**Hinweis:** Diese MR enthält bewusst nicht die SMS-Authentifizierung (echter SMS-Versand,
Telefonnummer-Kollisionsprüfung etc.) – die kommt über ein eigenes Ticket in einer separaten MR.
Für den BundID-Flow ist das ohne Bedeutung.
