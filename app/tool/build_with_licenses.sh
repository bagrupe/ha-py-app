#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
fvm flutter pub get
fvm dart run dart_pubspec_licenses:generate --json --ignore app -o assets/licenses/packages.json
fvm flutter build "$@"
