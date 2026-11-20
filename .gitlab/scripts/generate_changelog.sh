#!/usr/bin/env bash
# Generate Markdown changelog from commits via GitLab REST API (curl only in this script).
#
# Why not GET /repository/changelog (GitLab Changelog API)? That API renders from
# .gitlab/changelog_config.yml using rules on commit titles (e.g. conventional commits).
# It does not read the Changelog: git trailer, so it cannot express team semantics such as
# Changelog: other → non–source-code changes (see ### Miscellaneous below).
#
# Parses git trailer "Changelog: <value>" (case-insensitive key) into sections.
# Breaking commits (! before : or BREAKING CHANGE in body) go under ### Breaking changes first.
#
# Required for API mode: CI_API_V4_URL, CI_PROJECT_ID, CI_PROJECT_URL, and API_TOKEN or CI_JOB_TOKEN.
# In GitLab CI, CI_API_V4_URL and CI_JOB_TOKEN are set automatically; use API_TOKEN if you use a PAT.
#
# Local console testing (optional): hit the same endpoint with glab, e.g.
#   glab api "projects/$CI_PROJECT_ID/repository/compare?from=<ref>&to=<ref>"
# Do not call glab from automation; scripts use curl only.
#
# Usage:
#   generate_changelog.sh release [from_ref] to_ref
#     Prints Markdown fragment (### Breaking changes / ### Added / ...) for commits in (from_ref, to_ref].
#     If from_ref is omitted or empty, compares from the root commit reachable from to_ref.
#
#   generate_changelog.sh production-md
#     Prints full CHANGELOG.md for production tags only (backend-v* / app-v* without -staging or -RC).

set -euo pipefail

: "${CI_PROJECT_ID:?Set CI_PROJECT_ID (GitLab project id)}"
: "${CI_PROJECT_URL:?Set CI_PROJECT_URL}"

_trailer_section() {
  local msg="$1"
  local line val
  # Last line matching Changelog: (footer-style trailer; works without tac for macOS/BSD)
  line=$(printf '%s\n' "$msg" | awk '
    /^[Cc][hH][aA][nN][gG][eE][lL][oO][gG]:/ { buf = $0 }
    END { if (buf != "") print buf }
  ')
  if [[ -z "$line" ]]; then
    echo "Changed"
    return
  fi
  val=$(printf '%s' "$line" | sed -E 's/^[Cc]hangelog:[[:space:]]*//;s/[[:space:]]+$//')
  val=$(printf '%s' "$val" | tr '[:upper:]' '[:lower:]')
  # Section names align with commitlint.config.js validTypes (gitlab-changelog-trailer)
  case "$val" in
    added) echo "Added" ;;
    changed) echo "Changed" ;;
    deprecated) echo "Deprecated" ;;
    removed) echo "Removed" ;;
    fixed) echo "Fixed" ;;
    security) echo "Security" ;;
    performance) echo "Performance" ;;
    documentation) echo "Documentation" ;;
    dependencies) echo "Dependencies" ;;
    other) echo "Miscellaneous" ;; # ci, chore (non-dep), revert, etc.
    *) echo "Changed" ;;
  esac
}

# Conventional Commits: type(scope)!: subject, or BREAKING CHANGE / BREAKING-CHANGE in body.
_is_breaking_commit() {
  local title="$1" message="$2"
  # Use grep -E (not bash [[ =~ ]]) so macOS bash 3.2 accepts the pattern.
  if printf '%s' "$title" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([^)]*\))?!:'; then
    return 0
  fi
  if printf '%s' "$message" | grep -qiE '(^|[[:space:]])BREAKING[[:space:]]-?CHANGE:'; then
    return 0
  fi
  return 1
}

_release_section() {
  local title="$1" message="$2"
  if _is_breaking_commit "$title" "$message"; then
    echo "Breaking changes"
    return
  fi
  _trailer_section "$message"
}

_bucket_file() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

_ensure_api_creds() {
  if [[ -z "${API_TOKEN:-}" ]] && [[ -z "${CI_JOB_TOKEN:-}" ]]; then
    echo "generate_changelog.sh: set API_TOKEN or CI_JOB_TOKEN" >&2
    exit 1
  fi
  if [[ -z "${CI_API_V4_URL:-}" ]]; then
    echo "generate_changelog.sh: set CI_API_V4_URL (e.g. https://gitlab.example.com/api/v4)" >&2
    exit 1
  fi
}

_compare_json() {
  local from_ref="$1"
  local to_ref="$2"
  local enc_from enc_to url hdr
  enc_from=$(printf '%s' "$from_ref" | jq -sRr @uri)
  enc_to=$(printf '%s' "$to_ref" | jq -sRr @uri)
  url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/repository/compare?from=${enc_from}&to=${enc_to}"

  if [[ -n "${API_TOKEN:-}" ]]; then
    hdr="PRIVATE-TOKEN: ${API_TOKEN}"
  else
    hdr="JOB-TOKEN: ${CI_JOB_TOKEN}"
  fi

  curl --silent --show-error --fail --header "$hdr" "$url"
}

_release_from_git_log() {
  local from_ref="$1"
  local to_ref="$2"
  local range
  if [[ -n "$from_ref" ]]; then
    range="${from_ref}..${to_ref}"
  else
    range="$to_ref"
  fi
  git log --reverse --format=$'%H\t%s' "$range"
}

_render_from_compare_json() {
  local json="$1"
  local tmp sorted_sections line section title short_id web_url message
  tmp=$(mktemp -d)

  if ! echo "$json" | jq -e '.commits | type == "array"' >/dev/null 2>&1; then
    rm -rf "$tmp"
    return 1
  fi

  sorted_sections=(
    Breaking changes
    Added
    Changed
    Deprecated
    Removed
    Fixed
    Security
    Performance
    Documentation
    Dependencies
    Miscellaneous
  )

  while IFS= read -r row; do
    [[ -z "$row" ]] && continue
    title=$(echo "$row" | jq -r '.title // empty')
    short_id=$(echo "$row" | jq -r '.short_id // empty')
    web_url=$(echo "$row" | jq -r '.web_url // empty')
    message=$(echo "$row" | jq -r '.message // empty')
    section=$(_release_section "$title" "$message")
    if [[ -z "$web_url" || "$web_url" == "null" ]]; then
      id=$(echo "$row" | jq -r '.id // empty')
      web_url="${CI_PROJECT_URL}/-/commit/${id}"
    fi
    line="- ${title} ([${short_id}](${web_url}))"
    f="$tmp/$(_bucket_file "$section")"
    printf '%s\n' "$line" >>"$f"
  done < <(echo "$json" | jq -c '.commits | reverse | .[]')

  local any=0
  for section in "${sorted_sections[@]}"; do
    f="$tmp/$(_bucket_file "$section")"
    if [[ -s "$f" ]]; then
      any=1
      echo "### ${section}"
      cat "$f"
      echo ""
    fi
  done

  if [[ "$any" -eq 0 ]]; then
    echo "No changes recorded."
  fi

  rm -rf "$tmp"
}

_render_from_git_fallback() {
  local from_ref="$1"
  local to_ref="$2"
  local tmp sorted_sections section title id short line msg
  tmp=$(mktemp -d)
  sorted_sections=(
    Breaking changes
    Added
    Changed
    Deprecated
    Removed
    Fixed
    Security
    Performance
    Documentation
    Dependencies
    Miscellaneous
  )

  while IFS=$'\t' read -r id title; do
    [[ -z "$id" ]] && continue
    msg=$(git log -1 --format=%B "$id" 2>/dev/null || true)
    section=$(_release_section "$title" "$msg")
    short=$(git rev-parse --short "$id" 2>/dev/null || printf '%.8s' "$id")
    line="- ${title} ([${short}](${CI_PROJECT_URL}/-/commit/${id}))"
    f="$tmp/$(_bucket_file "$section")"
    printf '%s\n' "$line" >>"$f"
  done < <(_release_from_git_log "$from_ref" "$to_ref")

  local any=0
  for section in "${sorted_sections[@]}"; do
    f="$tmp/$(_bucket_file "$section")"
    if [[ -s "$f" ]]; then
      any=1
      echo "### ${section}"
      cat "$f"
      echo ""
    fi
  done

  if [[ "$any" -eq 0 ]]; then
    echo "No changes recorded."
  fi

  rm -rf "$tmp"
}

cmd_release() {
  local from_ref="${1:-}"
  local to_ref="${2:?release: missing to_ref}"
  if [[ -n "$from_ref" && "$from_ref" == "$to_ref" ]]; then
    echo "No changes recorded."
    return
  fi

  _ensure_api_creds

  local from_for_api="$from_ref"
  if [[ -z "$from_for_api" ]]; then
    from_for_api=$(git rev-list --max-parents=0 "$to_ref" 2>/dev/null | tail -1)
    if [[ -z "$from_for_api" ]]; then
      echo "generate_changelog.sh: could not resolve root for $to_ref" >&2
      exit 1
    fi
  fi

  local json
  if json=$(_compare_json "$from_for_api" "$to_ref" 2>/dev/null); then
    if echo "$json" | jq -e '.commits | length > 0' >/dev/null 2>&1; then
      _render_from_compare_json "$json"
      return
    fi
  fi

  echo "generate_changelog.sh: repository/compare via curl empty or failed, using git log" >&2
  _render_from_git_fallback "$from_ref" "$to_ref"
}

cmd_production_md() {
  _ensure_api_creds

  cat <<'HEADER'
# Changelog

All notable changes for **production** releases (`backend-v*` / `app-v*`), excluding tags containing `-staging` or `-RC`.

## Backend

HEADER

  local -a backend_tags=()
  while IFS= read -r t; do
    [[ -n "$t" ]] && backend_tags+=("$t")
  done < <(git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/tags |
    grep -E '^backend-v' | grep -Ev -- '-(staging|RC)' || true)

  local i from tag date body
  for i in "${!backend_tags[@]}"; do
    tag="${backend_tags[$i]}"
    if ((i + 1 < ${#backend_tags[@]})); then
      from="${backend_tags[$((i + 1))]}"
    else
      from=""
    fi
    date=$(git log -1 --format=%cs "$tag" 2>/dev/null || echo "")
    echo "### [${tag}] - ${date}"
    echo ""
    cmd_release "$from" "$tag" || true
    echo ""
  done

  cat <<'MID'

## App

MID

  local -a app_tags=()
  while IFS= read -r t; do
    [[ -n "$t" ]] && app_tags+=("$t")
  done < <(git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/tags |
    grep -E '^app-v' | grep -Ev -- '-(staging|RC)' || true)

  for i in "${!app_tags[@]}"; do
    tag="${app_tags[$i]}"
    if ((i + 1 < ${#app_tags[@]})); then
      from="${app_tags[$((i + 1))]}"
    else
      from=""
    fi
    date=$(git log -1 --format=%cs "$tag" 2>/dev/null || echo "")
    echo "### [${tag}] - ${date}"
    echo ""
    cmd_release "$from" "$tag" || true
    echo ""
  done
}

main() {
  local sub="${1:?usage: generate_changelog.sh release [from] to | production-md}"
  shift
  case "$sub" in
    release)
      cmd_release "$@"
      ;;
    production-md)
      cmd_production_md "$@"
      ;;
    *)
      echo "Unknown command: $sub" >&2
      exit 1
      ;;
  esac
}

main "$@"
