#!/usr/bin/env bash
# Lädt alle Dateien der neuesten Version eines GitLab Generic Packages (nach created_at).
# Nutzung: download_generic_package.sh <zielverzeichnis> [package-name]
# Package-Name: Arg 2, sonst GENERIC_PACKAGE_NAME, sonst krl-seeding-data.
#
# CI: CI_API_V4_URL, CI_PROJECT_ID, CI_JOB_TOKEN (automatisch gesetzt).
# Lokal: API_TOKEN (read_api), oder glab (glab auth login --hostname …),
# optional CI_API_V4_URL / CI_PROJECT_ID (Defaults: Ergosign GitLab, Projekt 1244).
set -euo pipefail

OUT_DIR="${1:?output directory required}"
PACKAGE_NAME="${2:-${GENERIC_PACKAGE_NAME:-krl-seeding-data}}"

API_URL="${CI_API_V4_URL:-https://gitlab.ergosign-projects.com/api/v4}"
API_URL="${API_URL%/}"
PROJECT_ID="${CI_PROJECT_ID:-1244}"
GITLAB_HOST="${API_URL#*://}"
GITLAB_HOST="${GITLAB_HOST%%/*}"

glab_api_token() {
  command -v glab >/dev/null 2>&1 || return 1
  local t=""
  t="$(glab config get token --host "$GITLAB_HOST" 2>/dev/null || true)"
  if [[ -z "$t" ]]; then
    t="$(glab config get token 2>/dev/null || true)"
  fi
  [[ -n "$t" ]] || return 1
  printf '%s' "$t"
}

curl_auth_header() {
  if [[ -n "${API_TOKEN:-}" ]]; then
    printf 'PRIVATE-TOKEN: %s' "$API_TOKEN"
  elif [[ -n "${CI_JOB_TOKEN:-}" ]]; then
    printf 'JOB-TOKEN: %s' "$CI_JOB_TOKEN"
  else
    local glab_token=""
    glab_token="$(glab_api_token || true)"
    if [[ -n "$glab_token" ]]; then
      printf 'PRIVATE-TOKEN: %s' "$glab_token"
    else
      echo "download_generic_package.sh: set API_TOKEN (read_api), CI_JOB_TOKEN, or configure glab (glab auth login --hostname ${GITLAB_HOST})" >&2
      exit 1
    fi
  fi
}

AUTH_HEADER="$(curl_auth_header)"
if [[ -z "${API_TOKEN:-}" ]] && [[ -z "${CI_JOB_TOKEN:-}" ]]; then
  echo "Authentifizierung über glab (${GITLAB_HOST})."
fi

mkdir -p "$OUT_DIR"

packages="$(
  curl -sf --header "${AUTH_HEADER}" \
    "${API_URL}/projects/${PROJECT_ID}/packages?package_type=generic&package_name=${PACKAGE_NAME}&per_page=100&order_by=created_at&sort=desc"
)"

latest="$(echo "$packages" | jq -c '.[0] // empty')"

if [[ -z "$latest" ]]; then
  echo "Kein Generic Package '${PACKAGE_NAME}' gefunden." >&2
  exit 1
fi

package_id="$(echo "$latest" | jq -r '.id')"
version="$(echo "$latest" | jq -r '.version')"
created_at="$(echo "$latest" | jq -r '.created_at')"
echo "Package ${PACKAGE_NAME}@${version} (id=${package_id}, created_at=${created_at})"

package_files="$(
  curl -sf --header "${AUTH_HEADER}" \
    "${API_URL}/projects/${PROJECT_ID}/packages/${package_id}/package_files?per_page=100"
)"

file_count=0
enc_version="$(jq -rn --arg v "$version" '$v|@uri')"
enc_name="$(jq -rn --arg n "$PACKAGE_NAME" '$n|@uri')"

while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  file_count=$((file_count + 1))
  enc_file="$(jq -rn --arg f "$file" '$f|@uri')"
  echo "Lade ${file} …"
  curl -sf --header "${AUTH_HEADER}" \
    "${API_URL}/projects/${PROJECT_ID}/packages/generic/${enc_name}/${enc_version}/${enc_file}" \
    -o "${OUT_DIR}/${file}"
done < <(echo "$package_files" | jq -r '.[].file_name')

if [[ "$file_count" -eq 0 ]]; then
  echo "Keine Dateien in Package ${PACKAGE_NAME}@${version}." >&2
  exit 1
fi

if [[ -f "${OUT_DIR}/SHA256SUMS" ]]; then
  echo "Prüfe SHA256SUMS …"
  (
    cd "$OUT_DIR"
    sha256sum -c SHA256SUMS
  )
fi

echo "Package ${PACKAGE_NAME}@${version}: ${file_count} Datei(en) nach ${OUT_DIR} geladen."
