#!/usr/bin/env bash
# Entfernt "firstName" aus den Pflichtfeldern des User-Profils (Realm "kommunalapp").
#
# Hintergrund: Bei BundID ist der Vorname optional (Nutzer können ihn beim Anlegen ihres
# BundID-Kontos über "Nicht zutreffend" leer lassen, z.B. bei nur einem Namen). Keycloaks
# Standard-User-Profile-Konfiguration markiert firstName aber als Pflichtfeld. Diese Prüfung ist
# realm-weit und unabhängig vom "first broker login"-Flow (siehe configure-bundid-flow.sh) — sie
# greift bei JEDEM Login, sobald ein Pflichtfeld leer ist, und zeigt dann ebenfalls Keycloaks
# "Update Account Information"-Seite. lastName bleibt Pflichtfeld, da BundID das immer liefert.
#
# Wie bei configure-bundid-idp.sh: komplettes Config-Objekt lesen, lokal ändern, als Ganzes
# zurückschreiben, um den Rest der Konfiguration (Validierungen, Berechtigungen) nicht zu
# verlieren.
#
# Idempotent: kann beliebig oft ausgeführt werden.

set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8081}"
REALM="${KEYCLOAK_REALM:-kommunalapp}"
ADMIN_USER="${KEYCLOAK_ADMIN_USER:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:?KEYCLOAK_ADMIN_PASSWORD muss gesetzt sein}"

echo "Hole Admin-Access-Token..."
ADMIN_TOKEN="$(curl -sf \
  -d "client_id=admin-cli" \
  -d "username=${ADMIN_USER}" \
  -d "password=${ADMIN_PASSWORD}" \
  -d "grant_type=password" \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" | \
  python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')"

echo "Lade aktuelle User-Profile-Konfiguration..."
CURRENT_PROFILE="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/users/profile")"

echo "Entferne 'required' von firstName..."
UPDATED_PROFILE="$(CURRENT_PROFILE_JSON="$CURRENT_PROFILE" python3 - <<'PYEOF'
import json, os

profile = json.loads(os.environ["CURRENT_PROFILE_JSON"])
first_name = next(a for a in profile["attributes"] if a["name"] == "firstName")
first_name.pop("required", None)

print(json.dumps(profile))
PYEOF
)"

curl -sf -X PUT \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$UPDATED_PROFILE" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/users/profile"

echo "Fertig. 'firstName' ist jetzt kein Pflichtfeld mehr."
