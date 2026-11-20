#!/usr/bin/env bash
# Vereinfacht die HaPy-Gemeindeflächen für das LageHelfer-Demo-Seeding.
#
# Liest web/bereich-b/src/dataseeder/HaPy_Gemeindeflaechen.json und schreibt pro Gemeinde
# (Schlüssel = "Beschriftung") eine vereinfachte GeoJSON-Geometrie nach
# backend/API/Seeders/LageHelfer/Geo/hapy-gemeinden.json.
#
# Vereinfachung: Punkte, die weniger als TOLERANCE Grad (ca. 90 m) vom zuletzt behaltenen
# Punkt entfernt sind, entfallen; Koordinaten werden auf 5 Nachkommastellen gerundet.
#
# Voraussetzung: jq
# Aufruf (beliebiges Verzeichnis): scripts/simplify_gemeindeflaechen.sh
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE="$ROOT/web/bereich-b/src/dataseeder/HaPy_Gemeindeflaechen.json"
TARGET="$ROOT/backend/API/Seeders/LageHelfer/Geo/hapy-gemeinden.json"
TOLERANCE="${TOLERANCE:-0.0008}"

if ! command -v jq >/dev/null 2>&1; then
  echo "jq wird benötigt (z.B. 'brew install jq')." >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET")"

jq -c --argjson tol "$TOLERANCE" '
  def round5: (. * 100000 | round) / 100000;

  # Ring ohne Schlusspunkt ausdünnen, danach wieder schließen; null, wenn kein Polygon übrig bleibt.
  def simplify_ring:
    .[:-1] as $open
    | (reduce $open[1:][] as $p ([$open[0]];
        .[-1] as $last
        | if (((($p[0] - $last[0]) | . * .) + (($p[1] - $last[1]) | . * .)) | sqrt) >= $tol
          then . + [$p] else . end)) as $kept
    | if ($kept | length) < 3 then null
      else ($kept + [$kept[0]]) | map(map(round5)) end;

  def simplify_polygon:
    map(simplify_ring) as $rings
    | if $rings[0] == null then null else $rings | map(select(. != null)) end;

  def simplify_geometry:
    if .type == "Polygon" then
      {type: "Polygon", coordinates: (.coordinates | simplify_polygon)}
    else
      {type: "MultiPolygon",
       coordinates: [.coordinates[] | simplify_polygon | select(. != null)]}
    end;

  [.features[] | {key: .properties.Beschriftung, value: (.geometry | simplify_geometry)}]
  | from_entries
' "$SOURCE" >"$TARGET"

echo "$(jq 'length' "$TARGET") Gemeinden nach $TARGET geschrieben ($(($(wc -c <"$TARGET") / 1024)) KiB)"
