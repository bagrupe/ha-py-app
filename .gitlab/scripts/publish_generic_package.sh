#!/usr/bin/env bash
# Veröffentlicht alle Dateien eines Verzeichnisses als GitLab Generic Package (eine Version).
# Nutzung: publish_generic_package.sh <quellverzeichnis> [package-name]
# Package-Name: Arg 2, sonst GENERIC_PACKAGE_NAME, sonst krl-seeding-data.
# Version: PACKAGE_VERSION oder UTC-Zeitstempel (date -u +%Y%m%dT%H%M%SZ).
set -euo pipefail

SOURCE_DIR="${1:?source directory required}"
PACKAGE_NAME="${2:-${GENERIC_PACKAGE_NAME:-krl-seeding-data}}"

API_URL="${CI_API_V4_URL:?CI_API_V4_URL required}"
PROJECT_ID="${CI_PROJECT_ID:?CI_PROJECT_ID required}"
TOKEN="${CI_JOB_TOKEN:?CI_JOB_TOKEN required}"

VERSION="${PACKAGE_VERSION:-$(date -u +%Y%m%dT%H%M%SZ)}"
STAGING_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGING_DIR"' EXIT

file_count=0
for f in "$SOURCE_DIR"/*; do
  [[ -f "$f" ]] || continue
  base="$(basename "$f")"
  [[ "$base" = SHA256SUMS ]] && continue
  cp "$f" "$STAGING_DIR/"
  file_count=$((file_count + 1))
done

if [[ "$file_count" -eq 0 ]]; then
  echo "Keine Dateien in ${SOURCE_DIR}." >&2
  exit 1
fi

(
  cd "$STAGING_DIR"
  sha256sum -- * > SHA256SUMS.tmp
  mv SHA256SUMS.tmp SHA256SUMS
)

upload() {
  local file="$1"
  local enc_version enc_name enc_file
  enc_version="$(jq -rn --arg v "$VERSION" '$v|@uri')"
  enc_name="$(jq -rn --arg n "$PACKAGE_NAME" '$n|@uri')"
  enc_file="$(jq -rn --arg f "$file" '$f|@uri')"
  curl -sf --header "JOB-TOKEN: ${TOKEN}" \
    --upload-file "${STAGING_DIR}/${file}" \
    "${API_URL}/projects/${PROJECT_ID}/packages/generic/${enc_name}/${enc_version}/${enc_file}"
  echo "Hochgeladen: ${PACKAGE_NAME}@${VERSION}/${file}"
}

upload SHA256SUMS
for f in "$STAGING_DIR"/*; do
  base="$(basename "$f")"
  [[ "$base" = SHA256SUMS ]] && continue
  upload "$base"
done

echo "Package ${PACKAGE_NAME}@${VERSION}: ${file_count} Datei(en) + SHA256SUMS veröffentlicht."
