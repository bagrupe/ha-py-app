#!/bin/sh
set -eu

probe() {
  url="$1"
  if curl -sf --max-time "${HEALTH_PROBE_TIMEOUT:-5}" "$url" >/dev/null; then
    echo "Healthy"
  else
    echo "Unhealthy"
  fi
}

backend_check=$(probe "http://${BACKEND_HOST}:8080/health/ready")
cms_check=$(probe "${CMS_UPSTREAM}/cms/health/ready")

if [ "$backend_check" = "Healthy" ] && [ "$cms_check" = "Healthy" ]; then
  status="Healthy"
  http_status="200 OK"
else
  status="Unhealthy"
  http_status="503 Service Unavailable"
fi

printf 'Content-Type: application/json\r\nStatus: %s\r\n\r\n' "$http_status"
printf '{"status":"%s","checks":{"backend":"%s","cms":"%s"}}\n' "$status" "$backend_check" "$cms_check"
