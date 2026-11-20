#!/usr/bin/env bash
# Löscht alle per BundID verknüpften Test-Accounts lokal (Keycloak-User + Backend-Bürgerkonten),
# damit dieselbe echte BundID beim nächsten Login wieder wie eine komplette Neuregistrierung
# behandelt wird — inklusive einer eventuell hinterlegten Telefonnummer, die sonst als "bereits
# vergeben" jede künftige Übernahme durch ein neues Test-Konto blockieren würde.
#
# Hintergrund: Keycloak legt beim ersten Login über den BundID-Broker einen lokalen "Schatten"-User
# an und merkt sich die Verknüpfung zur echten BundID (federated identity) — bei jedem weiteren
# Login mit derselben BundID wird dieser bestehende User wiedererkannt, nicht neu angelegt. Das
# Backend verknüpft diesen Keycloak-User zusätzlich über einen eigenen ExternalIdentity-Eintrag
# (Tabelle "ExternalIdentities", Provider "bundid") mit einem Bürger-Konto (Tabelle "Users"). Für
# eine echte End-to-end-Neuregistrierung müssen alle drei weg — nicht nur die Verknüpfung, sonst
# bleibt das alte Bürgerkonto samt seiner (unverifiziert) übernommenen Telefonnummer bestehen.
#
# Voraussetzung: lokale Docker-Umgebung läuft (docker/docker-compose.local.yml) — Keycloak
# erreichbar unter http://localhost:8081, Backend-Postgres im Container "hameln-postgres".
#
# Nur für lokale Entwicklung gedacht — arbeitet ausschließlich gegen lokale Container-Namen/Ports,
# kann also nicht versehentlich gegen Staging/Produktion laufen.

set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8081}"
REALM="${KEYCLOAK_REALM:-kommunalapp}"
IDP_ALIAS="${KEYCLOAK_IDP_ALIAS:-bundid}"
ADMIN_USER="${KEYCLOAK_ADMIN_USER:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-admin}"

BACKEND_DB_CONTAINER="${BACKEND_DB_CONTAINER:-hameln-postgres}"
BACKEND_DB_USER="${BACKEND_DB_USER:-admin}"
BACKEND_DB_NAME="${BACKEND_DB_NAME:-db}"

echo "Hole Keycloak-Admin-Access-Token..."
ADMIN_TOKEN="$(curl -sf \
  -d "client_id=admin-cli" \
  -d "username=${ADMIN_USER}" \
  -d "password=${ADMIN_PASSWORD}" \
  -d "grant_type=password" \
  "${KEYCLOAK_URL}/realms/master/protocol/openid-connect/token" |
  python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')"

echo "Suche Keycloak-User mit Identity Provider '${IDP_ALIAS}' im Realm '${REALM}'..."
USER_IDS="$(curl -sf \
  -H "Authorization: Bearer ${ADMIN_TOKEN}" \
  "${KEYCLOAK_URL}/admin/realms/${REALM}/users?idpAlias=${IDP_ALIAS}&max=1000" |
  python3 -c 'import json,sys; print("\n".join(u["id"] for u in json.load(sys.stdin)))')"

if [[ -z "$USER_IDS" ]]; then
  echo "Keine BundID-verknüpften Keycloak-User gefunden."
else
  while IFS= read -r user_id; do
    [[ -z "$user_id" ]] && continue
    echo "Lösche Keycloak-User ${user_id}..."
    curl -sf -X DELETE \
      -H "Authorization: Bearer ${ADMIN_TOKEN}" \
      "${KEYCLOAK_URL}/admin/realms/${REALM}/users/${user_id}"
  done <<<"$USER_IDS"
fi

echo "Suche per BundID angelegte Bürgerkonten in der Backend-Datenbank (Container ${BACKEND_DB_CONTAINER})..."
BUERGER_IDS="$(docker exec "$BACKEND_DB_CONTAINER" psql -U "$BACKEND_DB_USER" -d "$BACKEND_DB_NAME" \
  -t -A -c "SELECT \"BuergerId\" FROM \"ExternalIdentities\" WHERE \"Provider\" = 'bundid';")"

echo "Lösche BundID-Verknüpfungen in der Backend-Datenbank..."
docker exec "$BACKEND_DB_CONTAINER" psql -U "$BACKEND_DB_USER" -d "$BACKEND_DB_NAME" \
  -c "DELETE FROM \"ExternalIdentities\" WHERE \"Provider\" = 'bundid';"

if [[ -z "$BUERGER_IDS" ]]; then
  echo "Keine per BundID angelegten Bürgerkonten gefunden."
else
  while IFS= read -r buerger_id; do
    [[ -z "$buerger_id" ]] && continue
    echo "Lösche Bürgerkonto ${buerger_id} (gibt u.a. eine ggf. hinterlegte Telefonnummer wieder frei)..."
    # Nicht fatal, falls das Konto noch andere Daten hat (z.B. Anträge) und die Löschung deshalb an
    # einem Fremdschlüssel scheitert — betrifft dann eher kein reines Test-Konto, lieber überspringen
    # als das ganze Skript abbrechen zu lassen.
    docker exec "$BACKEND_DB_CONTAINER" psql -U "$BACKEND_DB_USER" -d "$BACKEND_DB_NAME" \
      -c "DELETE FROM \"Users\" WHERE \"Id\" = '${buerger_id}';" ||
      echo "  Übersprungen (vermutlich noch mit anderen Daten verknüpft)."
  done <<<"$BUERGER_IDS"
fi

echo "Gebe verbliebene, nicht mehr BundID-verknüpfte Telefonnummern-Kollisionen frei..."
# Deckt Konten ab, deren BundID-Verknüpfung schon vor diesem Skript-Lauf verloren ging (z.B. durch
# frühere manuelle Aufräumaktionen) — die blockieren sonst weiterhin jede künftige Übernahme
# derselben Nummer, obwohl sie längst nicht mehr mit BundID verknüpft sind. Bewusst ein Reset der
# Telefon-Spalten statt eines Lösch-Versuchs der ganzen Zeile (umgeht Fremdschlüssel-Probleme durch
# andere, echte Daten auf dem Konto) — nur sinnvoll auf einer rein lokalen Testdatenbank wie dieser,
# da hier nicht zwischen "BundID-Test-Altlast" und "echtes Testkonto mit Telefonnummer" unterschieden
# werden kann.
#
# Auch IsRegistered/Vorname/Nachname/Adressfelder werden hier mit zurückgesetzt: sonst bleibt ein
# Konto, das schon einmal (z.B. über den einfachen SMS-Pfad) als registriert markiert wurde, genau
# das auch nach diesem Skript — eine erneute lokale Test-Anmeldung mit derselben oder einer neu
# vergebenen Nummer landet dann auf einem "registrierten" Konto ohne jegliche Profildaten, statt wie
# erwartet das Neuregistrierungs-Formular zu zeigen (siehe EhrenamtsbankAuthService.ValidateSmsCode:
# IsNewRegistration hängt an "war IsRegistered vorher schon true").
docker exec "$BACKEND_DB_CONTAINER" psql -U "$BACKEND_DB_USER" -d "$BACKEND_DB_NAME" \
  -c "UPDATE \"Users\" SET \"Phone\" = NULL, \"PhoneHash\" = NULL, \"PhoneVerified\" = false,
      \"IsRegistered\" = false, \"RegisteredAt\" = NULL, \"Vorname\" = NULL, \"Nachname\" = NULL,
      \"EmailAddress\" = NULL, \"Street\" = NULL, \"PostalCode\" = NULL, \"City\" = NULL,
      \"Country\" = NULL, \"BundIdDatenSyncedAt\" = NULL
      WHERE \"Phone\" IS NOT NULL OR \"IsRegistered\" = true;"

echo "Fertig. Die BundID kann jetzt wieder als komplette Neuregistrierung getestet werden."
