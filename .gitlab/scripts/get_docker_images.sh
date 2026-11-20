#!/bin/bash

# DESCRIPTION:
#   Resolves Docker image tags from the GitLab Container Registry for deployment.
#   Uses merged Git tags at the current commit as a "time machine":
#   - backend-*  -> backend, web-bereich-a, web-bereich-b (unified release)
#   - app-*      -> APP_IMAGE_VERSION (Flutter app, not a Docker image)

# ==============================================================================
# CONFIGURATION
# ==============================================================================

MODE=${1:-development}
OUTPUT_FILE=${2}

API_URL="${CI_API_V4_URL:-https://gitlab.example.invalid/api/v4/}"
PROJECT_ID="${CI_PROJECT_ID:-1244}"
AUTH_HEADER="JOB-TOKEN: ${CI_JOB_TOKEN:-}"
COMMIT_SHA="${CI_COMMIT_SHA:-HEAD}"

BACKEND_TAG_PREFIX="backend-"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

get_merged_tags() {
  git fetch --tags --quiet > /dev/null 2>&1
  git tag --merged "$COMMIT_SHA"
}

get_candidate_git_tags() {
  local tag_prefix="$1"
  local candidates=""

  if [ "$MODE" == "staging" ]; then
    candidates=$(echo "$MERGED_TAGS" | grep "^${tag_prefix}" | grep -E "\-staging(\.[0-9]+)?" | sort -Vr)
  elif [ "$MODE" == "preprod" ]; then
    candidates=$(echo "$MERGED_TAGS" | grep "^${tag_prefix}" | grep -E "\-RC(\.[0-9]+)?" | sort -Vr)
    [ -z "$candidates" ] && candidates=$(echo "$MERGED_TAGS" | grep "^${tag_prefix}" | grep -E "\-staging(\.[0-9]+)?" | sort -Vr)
  elif [ "$MODE" == "production" ]; then
    # Must end after patch version; otherwise backend-v1.0.0-staging.1 matches too
    candidates=$(echo "$MERGED_TAGS" | grep -E "^${tag_prefix}v[0-9]+\.[0-9]+\.[0-9]+$" | sort -Vr)
  fi

  echo "$candidates"
}

get_app_version(){
  local environment=""
  if [ "$MODE" == "staging" ]; then environment="staging"
  elif [ "$MODE" == "preprod" ]; then environment="RC"
  elif [ "$MODE" == "production" ]; then environment=""
  fi

  local app_tag
  app_tag=$(get_merged_tags | grep "^app-" | grep "$environment" | sort -V | tail -n 1)
  echo "$app_tag"
}

# ==============================================================================
# MAIN EXECUTION
# ==============================================================================

COMPONENTS=("backend" "web-bereich-a" "web-bereich-b" "stele" "keycloak")
MERGED_TAGS=$(get_merged_tags)

if [[ "$MODE" != "development" && "$MODE" != "staging" && "$MODE" != "preprod" && "$MODE" != "production" ]]; then
  echo "Error: Invalid argument '$MODE'. Use 'staging', 'preprod' or 'production'."
  exit 1
fi

echo "--- FETCHING $MODE IMAGE URIS (COMMIT: ${COMMIT_SHA:0:8}) ---" >&2

if [[ "$MODE" = "development" ]]; then
    for COMPONENT in "${COMPONENTS[@]}"; do
      VAR_NAME=$(echo "$COMPONENT" | tr '[:lower:]' '[:upper:]' | tr '-' '_')_IMAGE_VERSION
      [ -n "$OUTPUT_FILE" ] && echo "$VAR_NAME=latest" >> "$OUTPUT_FILE"
    done
    exit 0
fi

REPOS_JSON=$(curl --silent --header "$AUTH_HEADER" "$API_URL/projects/$PROJECT_ID/registry/repositories")
if [[ -z "$REPOS_JSON" || "$REPOS_JSON" == "[]" ]]; then
  echo "Error: No registry repositories found." >&2
  exit 1
fi


APP_VERSION=$(get_app_version)
[ -n "$OUTPUT_FILE" ] && echo "APP_IMAGE_VERSION=$APP_VERSION" >> "$OUTPUT_FILE"
for COMPONENT in "${COMPONENTS[@]}"; do
  VAR_NAME=$(echo "$COMPONENT" | tr '[:lower:]' '[:upper:]' | tr '-' '_')_IMAGE_VERSION
  REPO_INFO=$(echo "$REPOS_JSON" | jq -c ".[] | select(.name == \"$COMPONENT\")")

  if [ -z "$REPO_INFO" ]; then
    [ -n "$OUTPUT_FILE" ] && echo "$VAR_NAME=latest" >> "$OUTPUT_FILE"
    continue
  fi

  REPO_ID=$(echo "$REPO_INFO" | jq -r '.id')

  # PRIORITY 1: Check if the exact commit SHA exists in the registry
  SHA_STATUS=$(curl --silent -o /dev/null -w "%{http_code}" --header "$AUTH_HEADER" "$API_URL/projects/$PROJECT_ID/registry/repositories/$REPO_ID/tags/$COMMIT_SHA")

  LATEST_TAG=""


  if [[ "$SHA_STATUS" -eq 200 ]]; then
    LATEST_TAG="$COMMIT_SHA"
    echo "🎯 Found exact SHA tag for $COMPONENT: $LATEST_TAG" >&2
  else
    echo "⚠️ Exact SHA tag not found. Searching historical Git tags for $COMPONENT..." >&2

    # PRIORITY 2: Filter merged Git tags and translate to registry tags
    CANDIDATE_TAGS=$(get_candidate_git_tags "$BACKEND_TAG_PREFIX")

    for GIT_TAG in $CANDIDATE_TAGS; do
      VERSION="${GIT_TAG#$BACKEND_TAG_PREFIX}"
      EXPECTED_DOCKER_TAG="${COMPONENT}-${VERSION}"

      TAG_STATUS=$(curl --silent -o /dev/null -w "%{http_code}" --header "$AUTH_HEADER" "$API_URL/projects/$PROJECT_ID/registry/repositories/$REPO_ID/tags/$EXPECTED_DOCKER_TAG")

      if [[ "$TAG_STATUS" -eq 200 ]]; then
        LATEST_TAG="$EXPECTED_DOCKER_TAG"
        echo "🔍 Translated $GIT_TAG -> $LATEST_TAG (Found in Registry!)" >&2
        break
      fi
    done
  fi

  LATEST_TAG=${LATEST_TAG:-latest}
  [ -n "$OUTPUT_FILE" ] && echo "$VAR_NAME=$LATEST_TAG" >> "$OUTPUT_FILE"
  echo "✅ Set $VAR_NAME=$LATEST_TAG" >&2
done

echo "--- DONE ---" >&2
