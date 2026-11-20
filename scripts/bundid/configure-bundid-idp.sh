#!/usr/bin/env bash
# Spielt die vollständige BundID-SAML-IdP-Konfiguration (Alias "bundid", Realm "kommunalapp")
# als EIN vollständiges Config-Objekt über die Keycloak Admin REST API ein.
#
# Hintergrund: Eine partielle Änderung eines einzelnen Feldes (z.B. per `kcadm update ... -s
# config.allowedClockSkew=60`) hat in der Vergangenheit die übrige verschachtelte IdP-Konfiguration
# entfernt. Deshalb wird hier immer das komplette Objekt gelesen, lokal gemergt und als Ganzes
# zurückgeschrieben (PUT), nie ein Teil-Patch.
#
# Voraussetzungen:
#   - Keycloak läuft bereits (siehe docker/docker-compose.local.yml) und der Realm "kommunalapp"
#     wurde per Realm-Import angelegt (docker/keycloak/realm-kommunalapp.json, enthält den IdP
#     "bundid" bereits mit den öffentlichen/nicht-geheimen Feldern).
#   - bundid-secrets/keycloak/ enthält die vom Nutzer manuell kopierten, lokal erzeugten
#     RSA-4096-Schlüssel/Zertifikate (Signing + Encryption, getrennt) sowie BundIDs eigenes
#     INT-Signing-Zertifikat, siehe README.md dort.
#
# Wichtig — zwei unterschiedliche Zertifikate, nicht verwechseln:
#   - `signingCertificate` muss BundIDs eigenes INT-Zertifikat sein (verifiziert die von BundID
#     signierten SAML-Responses, s. `org.keycloak.broker.saml.SAMLEndpoint.verifySignature`) — NICHT
#     das SP-eigene Zertifikat. Steht dort fälschlich das SP-Zertifikat, schlägt jede Anmeldung mit
#     "Invalid signature on document" fehl, obwohl beide Setup-Skripte anstandslos durchlaufen.
#   - `encryptionPublicKey` bleibt das SP-eigene Encryption-Zertifikat (damit BundID Assertions an
#     uns verschlüsseln kann).
#
# Hinweis: Online-Service-ID und Organization-Display-Name (von BundID vorgeschriebene
# Pflichtangaben) sind KEIN Teil dieses IdP-config-Objekts, sondern SPI-Provider-Konfiguration der
# keycloak-extension-bundid und werden über Env-Variablen auf dem Keycloak-Container gesetzt
# (KC_SPI_SAML_AUTHENTICATION_PREPROCESSOR_BUNDID_PROTOCOL_ONLINE_SERVICE_ID /
# ..._ORGANIZATION_DISPLAY_NAME, siehe docker-compose.local.yml). Die angeforderten
# RequestedAttribute-OIDs (E-Mail/Vorname/Nachname) werden ebenfalls nicht hier, sondern über die
# saml-bundid-session-*-idp-mapper in docker/keycloak/realm-kommunalapp.json gesetzt.

set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8081}"
REALM="${KEYCLOAK_REALM:-kommunalapp}"
IDP_ALIAS="${KEYCLOAK_IDP_ALIAS:-bundid}"
ADMIN_USER="${KEYCLOAK_ADMIN_USER:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:?KEYCLOAK_ADMIN_PASSWORD muss gesetzt sein}"

SECRETS_DIR="${BUNDID_SECRETS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/bundid-secrets/keycloak}"
IDP_SIGNING_CERT_FILE="${SECRETS_DIR}/bundid-int-idp-signing.crt"
ENCRYPTION_CERT_FILE="${SECRETS_DIR}/bundid-saml-encryption.crt"

for f in "$IDP_SIGNING_CERT_FILE" "$ENCRYPTION_CERT_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "Fehlt: $f" >&2
    echo "Bitte zuerst die Zertifikate gemäß bundid-secrets/keycloak/README.md ablegen." >&2
    exit 1
  fi
done

strip_pem() {
  # Entfernt PEM-Header/Footer und Zeilenumbrüche, wie Keycloak es für signingCertificate/
  # encryptionPublicKey als reinen Base64-Block erwartet.
  grep -v -- "-----" "$1" | tr -d '\n'
}

IDP_SIGNING_CERT_B64="$(strip_pem "$IDP_SIGNING_CERT_FILE")"
ENCRYPTION_CERT_B64="$(strip_pem "$ENCRYPTION_CERT_FILE")"

echo "Hole Admin-Access-Token..."
ADMIN_TOKEN="$(curl -sf \
  -d "client_id=admin-cli" \
  -d "username=${ADMIN_USER}" \
  -d "password=${ADMIN_PASSWORD}" \
  -d "grant_type=password" \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" | \
  python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')"

echo "Lade aktuelle IdP-Konfiguration (${IDP_ALIAS})..."
CURRENT_IDP="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/identity-provider/instances/${IDP_ALIAS}")"

echo "Baue vollständiges Config-Objekt und schreibe es atomar zurück..."
UPDATED_IDP="$(CURRENT_IDP_JSON="$CURRENT_IDP" python3 - "$IDP_SIGNING_CERT_B64" "$ENCRYPTION_CERT_B64" <<'PYEOF'
import json, os, sys

signing_cert, encryption_cert = sys.argv[1], sys.argv[2]
idp = json.loads(os.environ["CURRENT_IDP_JSON"])

# Vollständiges, vorher geladenes config-Objekt mergen statt einzelner kcadm-Patches
# (siehe Kommentar am Kopf dieses Skripts).
idp["config"].update({
    "signingCertificate": signing_cert,
    "encryptionPublicKey": encryption_cert,
    "allowedClockSkew": "60",
})

print(json.dumps(idp))
PYEOF
)"

curl -sf -X PUT \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$UPDATED_IDP" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/identity-provider/instances/${IDP_ALIAS}"

echo "IdP '${IDP_ALIAS}' aktualisiert."
