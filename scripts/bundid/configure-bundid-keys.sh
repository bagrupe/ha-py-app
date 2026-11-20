#!/usr/bin/env bash
# Legt die beiden SP-eigenen Realm-Keys (Signing + Encryption) an, mit denen Keycloak
# ausgehende SAML-AuthnRequests an BundID signiert bzw. eingehende verschlüsselte Assertions
# entschlüsselt — ohne diese Keys verwendet Keycloak einen automatisch generierten Schlüssel, der
# bei BundID nicht registriert ist, und die Anmeldung schlägt fehl.
#
# Idempotent: existiert ein Key-Provider mit dem jeweiligen Namen bereits, wird er per PUT
# aktualisiert statt ein Duplikat anzulegen (kann also gefahrlos mehrfach laufen, z.B. nach einem
# Passwortwechsel der Keystores).
#
# Voraussetzungen:
#   - Keycloak läuft bereits (siehe docker/docker-compose.local.yml), Realm "kommunalapp" wurde
#     per Realm-Import angelegt.
#   - bundid-secrets/keycloak/bundid-saml-signing.p12 und .../bundid-saml-encryption.p12 liegen
#     bereits im gemounteten Secrets-Verzeichnis (siehe bundid-secrets/keycloak/README.md) —
#     dieses Skript liest sie nicht selbst, sondern trägt nur den Container-internen Pfad
#     (/opt/keycloak/bundid-secrets/...) in die Key-Provider-Config ein.
#   - Beide .p12-Dateien verwenden dasselbe Keystore-/Key-Passwort (BUNDID_KEYSTORE_PASSWORD).

set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8081}"
REALM="${KEYCLOAK_REALM:-kommunalapp}"
ADMIN_USER="${KEYCLOAK_ADMIN_USER:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:?KEYCLOAK_ADMIN_PASSWORD muss gesetzt sein}"
KEYSTORE_PASSWORD="${BUNDID_KEYSTORE_PASSWORD:?BUNDID_KEYSTORE_PASSWORD muss gesetzt sein (Passwort der .p12-Keystores)}"

# Fixer Mount-Punkt aus docker-compose.local.yml — Keycloak liest die Dateien selbst aus dem
# Container, nicht dieses Skript.
CONTAINER_SECRETS_DIR="/opt/keycloak/bundid-secrets"

echo "Hole Admin-Access-Token..."
ADMIN_TOKEN="$(curl -sf \
  -d "client_id=admin-cli" \
  -d "username=${ADMIN_USER}" \
  -d "password=${ADMIN_PASSWORD}" \
  -d "grant_type=password" \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" | \
  python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')"

echo "Hole interne Realm-ID (${REALM})..."
REALM_ID="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}" | \
  python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])')"

echo "Lade bestehende Key-Provider..."
EXISTING_PROVIDERS="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/components?type=org.keycloak.keys.KeyProvider")"

put_or_post_key_provider() {
  local name="$1" keystore_file="$2" key_alias="$3" algorithm="$4" key_use="$5"

  local existing_id
  existing_id="$(EXISTING_PROVIDERS_JSON="$EXISTING_PROVIDERS" NAME="$name" python3 -c '
import json, os
providers = json.loads(os.environ["EXISTING_PROVIDERS_JSON"])
match = next((p for p in providers if p.get("name") == os.environ["NAME"]), None)
print(match["id"] if match else "")
')"

  local body
  body="$(python3 - "$name" "$REALM_ID" "$keystore_file" "$key_alias" "$algorithm" "$key_use" "$KEYSTORE_PASSWORD" "$existing_id" <<'PYEOF'
import json, sys

name, realm_id, keystore_file, key_alias, algorithm, key_use, password, existing_id = sys.argv[1:9]

config = {
    "keystore": [keystore_file],
    "keystorePassword": [password],
    "keyPassword": [password],
    "keyAlias": [key_alias],
    "keystoreType": ["PKCS12"],
    "algorithm": [algorithm],
    "priority": ["200"],
    "enabled": ["true"],
    "active": ["true"],
}
if key_use:
    config["keyUse"] = [key_use]

component = {
    "name": name,
    "providerId": "java-keystore",
    "providerType": "org.keycloak.keys.KeyProvider",
    "parentId": realm_id,
    "config": config,
}
if existing_id:
    component["id"] = existing_id

print(json.dumps(component))
PYEOF
)"

  if [[ -n "$existing_id" ]]; then
    echo "Aktualisiere bestehenden Key-Provider '${name}'..."
    curl -sf -X PUT \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$body" \
      "${KEYCLOAK_URL}/admin/realms/${REALM}/components/${existing_id}"
  else
    echo "Lege neuen Key-Provider '${name}' an..."
    curl -sf -X POST \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      -H "Content-Type: application/json" \
      -d "$body" \
      "${KEYCLOAK_URL}/admin/realms/${REALM}/components"
  fi
}

put_or_post_key_provider \
  "bundid-saml-signing" \
  "${CONTAINER_SECRETS_DIR}/bundid-saml-signing.p12" \
  "bundid-saml-signing" \
  "RS256" \
  ""

put_or_post_key_provider \
  "bundid-saml-encryption" \
  "${CONTAINER_SECRETS_DIR}/bundid-saml-encryption.p12" \
  "bundid-saml-encryption" \
  "RSA-OAEP" \
  "enc"

echo "Realm-Keys 'bundid-saml-signing' und 'bundid-saml-encryption' eingerichtet."
