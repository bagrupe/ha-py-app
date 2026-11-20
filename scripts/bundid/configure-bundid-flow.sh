#!/usr/bin/env bash
# Deaktiviert den "Review Profile"-Schritt im First-Broker-Login-Flow des Realms "kommunalapp".
#
# Hintergrund: Nach einem erfolgreichen BundID-Login zeigt Keycloak standardmäßig eine eigene
# "Update Account Information"-Zwischenseite, bevor der Nutzer zurück in die App gelangt. Die App
# hat stattdessen einen eigenen Onboarding-Screen (nur bei Erstregistrierung), der mit den
# BundID-Daten vorausgefüllt ist. Damit Keycloak den föderierten Nutzer statt dessen still
# anlegt/wiedererkennt, muss die Execution "Review Profile" (providerId idp-review-profile) von
# REQUIRED auf DISABLED gesetzt werden.
#
# Diese Flow ist Realm-global (nicht IdP-spezifisch), aber "bundid" ist aktuell der einzige IdP in
# diesem Realm, daher unkritisch. Lässt sich nicht sauber deklarativ in realm-kommunalapp.json
# abbilden, da Keycloak die Standard-Flows automatisch beim Realm-Import anlegt.
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

echo "Lade Executions des 'first broker login'-Flows..."
EXECUTIONS="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/authentication/flows/first%20broker%20login/executions")"

REVIEW_PROFILE_EXECUTION="$(EXECUTIONS_JSON="$EXECUTIONS" python3 - <<'PYEOF'
import json, os

executions = json.loads(os.environ["EXECUTIONS_JSON"])
review_profile = next(e for e in executions if e.get("providerId") == "idp-review-profile")
review_profile["requirement"] = "DISABLED"
print(json.dumps(review_profile))
PYEOF
)"

echo "Setze 'Review Profile' auf DISABLED..."
curl -sf -X PUT \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  -H "Content-Type: application/json" \
  -d "$REVIEW_PROFILE_EXECUTION" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/authentication/flows/first%20broker%20login/executions"

echo "Fertig. 'Review Profile' ist jetzt DISABLED."
