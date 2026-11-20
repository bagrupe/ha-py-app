#!/bin/sh
# Prometheus container entrypoint.
# Substitutes environment-specific server IPs into prometheus.yml, generates
# blackbox probe targets (blackbox.probes.yml) from env vars, then starts Prometheus.
# Probe targets are written once at container start — restart Prometheus after env changes.
set -eu

sed \
  -e "s|\${STAGING_SERVER_IP}|${STAGING_SERVER_IP:-}|g" \
  -e "s|\${PREPROD_SERVER_IP}|${PREPROD_SERVER_IP:-}|g" \
  -e "s|\${PRODUCTION_SERVER_IP}|${PRODUCTION_SERVER_IP:-}|g" \
  /etc/prometheus/prometheus.yml > /tmp/prometheus.yml

TARGETS_DIR=/etc/prometheus/targets
mkdir -p "$TARGETS_DIR"
: > "$TARGETS_DIR/blackbox.probes.yml"

append_probe() {
  environment="$1"
  probe_type="$2"
  url="$3"
  module="${4:-http_2xx}"

  case "$url" in
    http://*|https://*) ;;
    *) return 0 ;;
  esac

  cat >> "$TARGETS_DIR/blackbox.probes.yml" <<EOF
- targets:
    - ${url}
  labels:
    environment: ${environment}
    probe_type: ${probe_type}
    module: ${module}

EOF
}

BACKEND_PORT="${BACKEND_PORT:-8080}"
BEREICH_B_PORT="${BEREICH_B_PORT:-3001}"
BEREICH_A_PORT="${BEREICH_A_PORT:-3000}"
STELE_PORT="${STELE_PORT:-8080}"

append_env_probes() {
  environment="$1"
  server_ip="$2"
  backend_port="$3"
  bereich_b_port="$4"
  bereich_a_port="$5"
  stele_port="$6"
  app_domain="$7"
  stele_domain="$8"

  if [ -n "$server_ip" ]; then
    append_probe "$environment" backend_ready "http://${server_ip}:${backend_port}/health/ready"
    append_probe "$environment" bereich_b_ready "http://${server_ip}:${bereich_b_port}/cms/health/ready"
    append_probe "$environment" bereich_a_ready "http://${server_ip}:${bereich_a_port}/health/ready"
    append_probe "$environment" stele_ready "http://${server_ip}:${stele_port}/health/ready"
  fi

  if [ -n "$app_domain" ]; then
    append_probe "$environment" public_app "https://${app_domain}/" https_2xx
  fi

  if [ -n "$stele_domain" ]; then
    append_probe "$environment" public_stele "https://${stele_domain}/" https_2xx
  fi
}

append_env_probes local \
  "${LOCAL_APP_HOST}" \
  "${LOCAL_BACKEND_PORT:-8080}" \
  "${LOCAL_BEREICH_B_PORT:-3001}" \
  "${LOCAL_BEREICH_A_PORT:-3000}" \
  "${LOCAL_STELE_PORT:-8080}" \
  "${LOCAL_APP_DOMAIN:-}" \
  "${LOCAL_STELE_DOMAIN:-}"

append_env_probes staging \
  "${STAGING_SERVER_IP:-}" \
  "$BACKEND_PORT" \
  "$BEREICH_B_PORT" \
  "$BEREICH_A_PORT" \
  "$STELE_PORT" \
  "${STAGING_APP_DOMAIN:-}" \
  "${STAGING_STELE_DOMAIN:-}"

append_env_probes preprod \
  "${PREPROD_SERVER_IP:-}" \
  "$BACKEND_PORT" \
  "$BEREICH_B_PORT" \
  "$BEREICH_A_PORT" \
  "$STELE_PORT" \
  "${PREPROD_APP_DOMAIN:-}" \
  "${PREPROD_STELE_DOMAIN:-}"

append_env_probes production \
  "${PRODUCTION_SERVER_IP:-}" \
  "$BACKEND_PORT" \
  "$BEREICH_B_PORT" \
  "$BEREICH_A_PORT" \
  "$STELE_PORT" \
  "${PRODUCTION_APP_DOMAIN:-}" \
  "${PRODUCTION_STELE_DOMAIN:-}"

exec /bin/prometheus \
  --config.file=/tmp/prometheus.yml \
  --storage.tsdb.path=/prometheus \
  --web.enable-lifecycle
