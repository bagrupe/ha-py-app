#!/usr/bin/env bash
# Starts Keycloak, waits until the management health endpoint is ready, then runs the BundID
# configure scripts (idempotent). Scripts and runtime secrets mount are separate: scripts ship in
# the image, certificates/JAR remain on the host under /opt/keycloak/bundid-secrets.
set -euo pipefail

KC_PID=""

term_handler() {
  if [[ -n "$KC_PID" ]] && kill -0 "$KC_PID" 2>/dev/null; then
    kill -TERM "$KC_PID"
    wait "$KC_PID" 2>/dev/null || true
  fi
}
trap term_handler SIGTERM SIGINT

run_bundid_configure() {
  local secrets_dir="${BUNDID_SECRETS_DIR:-/opt/keycloak/bundid-secrets}"
  local scripts_dir="/opt/keycloak/bundid-config"

  if [[ ! -f "${secrets_dir}/bundid-int-idp-signing.crt" ]]; then
    echo "BundID secrets not found at ${secrets_dir} — skipping configure scripts."
    return 0
  fi

  if [[ -z "${KEYCLOAK_ADMIN_PASSWORD:-}" ]]; then
    echo "KEYCLOAK_ADMIN_PASSWORD is not set — skipping BundID configure scripts."
    return 0
  fi

  if [[ -z "${BUNDID_KEYSTORE_PASSWORD:-}" ]]; then
    echo "BUNDID_KEYSTORE_PASSWORD is not set — skipping BundID configure scripts."
    return 0
  fi

  export KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8080}"
  export BUNDID_SECRETS_DIR="${secrets_dir}"
  export KEYCLOAK_ADMIN_USER="${KEYCLOAK_ADMIN_USER:-admin}"

  echo "Running BundID configure scripts against ${KEYCLOAK_URL}..."
  bash "${scripts_dir}/configure-bundid-idp.sh"
  bash "${scripts_dir}/configure-bundid-keys.sh"
  bash "${scripts_dir}/configure-bundid-flow.sh"
  echo "BundID configure scripts completed."
}

wait_for_keycloak_ready() {
  local attempts="${1:-120}"
  for _ in $(seq 1 "$attempts"); do
    if curl -sf http://localhost:9000/health/ready >/dev/null 2>&1; then
      return 0
    fi
    if [[ -n "$KC_PID" ]] && ! kill -0 "$KC_PID" 2>/dev/null; then
      echo "Keycloak process exited before becoming ready." >&2
      wait "$KC_PID" || true
      return 1
    fi
    sleep 2
  done
  echo "Keycloak did not become ready within $((attempts * 2)) seconds." >&2
  return 1
}

/opt/keycloak/bin/kc.sh "$@" &
KC_PID=$!

if ! wait_for_keycloak_ready; then
  exit 1
fi

if ! run_bundid_configure; then
  echo "WARNING: BundID configure scripts failed — Keycloak will continue running." >&2
fi

wait "$KC_PID"
