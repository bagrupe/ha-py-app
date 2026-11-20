#!/usr/bin/env bash
# Renders the nginx reverse proxy config from docker/nginx/*.conf.template using variables from a
# deployment .env file.
#
# Base template (always):    docker/nginx/reverse-proxy.conf.template
# Optional fragments:        docker/nginx/reverse-proxy.<name>.conf.template
#   - keycloak: appended unless KEYCLOAK_PROXY_ENABLED=false

set -euo pipefail

ENV_FILE="${1:-}"
OUTPUT_FILE="${2:-}"

if [ -z "$ENV_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $0 <env-file> <output-file>" >&2
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "Env file not found: $ENV_FILE" >&2
  exit 1
fi

# Export only deployment-related keys (avoid accidental substitution from unrelated vars).
set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

: "${APP_DOMAIN:?APP_DOMAIN must be set in the deployment env file}"
: "${STELE_DOMAIN:?STELE_DOMAIN must be set in the deployment env file}"

# Feature toggles. Default keeps Keycloak included.
KEYCLOAK_PROXY_ENABLED="$(echo "${KEYCLOAK_PROXY_ENABLED:-true}" | tr -d '\r"' | tr '[:upper:]' '[:lower:]')"
case "$KEYCLOAK_PROXY_ENABLED" in
  true | false) ;;
  *)
    echo "KEYCLOAK_PROXY_ENABLED must be 'true' or 'false' (got: '$KEYCLOAK_PROXY_ENABLED')" >&2
    exit 1
    ;;
esac

KEYCLOAK_HOSTNAME="${KEYCLOAK_HOSTNAME:app.example.invalid}"

export APP_DOMAIN STELE_DOMAIN KEYCLOAK_HOSTNAME

NGINX_DIR="$(cd "$(dirname "$0")/../.." && pwd)/docker/nginx"
BASE_TEMPLATE="$NGINX_DIR/reverse-proxy.conf.template"
KEYCLOAK_TEMPLATE="$NGINX_DIR/reverse-proxy.keycloak.conf.template"

TEMPLATES=("$BASE_TEMPLATE")
VARS='${APP_DOMAIN} ${STELE_DOMAIN}'

if [ "$KEYCLOAK_PROXY_ENABLED" = "true" ]; then
  # Deploy image is bash:3.0.22. Arrays exist, but += append was added in bash 3.1.
  TEMPLATES=("${TEMPLATES[@]}" "$KEYCLOAK_TEMPLATE")
  VARS="$VARS \${KEYCLOAK_HOSTNAME}"
fi

for template in "${TEMPLATES[@]}"; do
  if [ ! -f "$template" ]; then
    echo "Template not found: $template" >&2
    exit 1
  fi
done

if ! command -v envsubst >/dev/null 2>&1; then
  echo "envsubst not found (install gettext)" >&2
  exit 1
fi

: > "$OUTPUT_FILE"
for template in "${TEMPLATES[@]}"; do
  # Blank line between fragments keeps the rendered file readable.
  [ -s "$OUTPUT_FILE" ] && echo >> "$OUTPUT_FILE"
  envsubst "$VARS" < "$template" >> "$OUTPUT_FILE"
done

echo "Wrote nginx reverse proxy config to $OUTPUT_FILE (keycloak: $KEYCLOAK_PROXY_ENABLED)"
