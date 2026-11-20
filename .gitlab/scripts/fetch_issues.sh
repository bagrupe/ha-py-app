#!/bin/bash

# ==============================================================================
# Script Name: fetch_issues.sh
# Description:
#   This script fetches open issues from the GitLab project associated with a
#   specific deployment environment. It maps the provided environment name to
#   a corresponding GitLab label (e.g., Ready4DeploymentSTG) and generates a
#   Markdown report containing details of the matching issues.
#
#   The generated report includes the issue title, URL, milestone, labels, and
#   description.
#
# Usage:
#   ./fetch_issues.sh <environment> <tag>
#
# Parameters:
#   1. environment (Required): The target environment for deployment.
#      Allowed values:
#        - staging
#        - preprod
#        - production
#   2. tag (Required): The deployment tag (e.g., v1.0.0).
#
# Output:
#   Generates a Markdown file named "issues_<environment>.md" in the current
#   directory.
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

ENVIRONMENT=$1
TAG=$2

# ==========================================
# 1. Configuration (Update these values)
# ==========================================
API_URL="${CI_API_V4_URL:-https://gitlab.example.invalid/api/v4}"
PROJECT_ID="1244"
AUTH_HEADER="PRIVATE-TOKEN: ${API_TOKEN:-}"


# ==========================================
# 2. Input Validation & Environment Mapping
# ==========================================
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 {staging|preprod|production} <tag>"
    exit 1
fi

if [ -z "$TAG" ]; then
    echo "Error: Tag argument cannot be empty."
    exit 1
fi



# Define your labels for each environment here
case "$ENVIRONMENT" in
    staging)
        LABEL="Ready4DeploymentSTG"
        ;;
    preprod)
        LABEL="Ready4DeploymentPreProd"
        ;;
    production)
        LABEL="Ready4DeploymentProd"
        ;;
    *)
        echo "Error: Invalid environment '$ENVIRONMENT'. Use staging, preprod, or production."
        exit 1
        ;;
esac

# ==========================================
# 3. Fetch issues (GitLab API) and write Markdown report
# ==========================================
OUTPUT_FILE="issues_${TAG}.md"
echo "Fetching open issues for environment: $ENVIRONMENT (Label: $LABEL)..."
# Initialize the markdown file with a header
echo "# Issues for ${ENVIRONMENT} Deployment of ${TAG}" > "$OUTPUT_FILE"
echo "**Target Label:** \`$LABEL\`" >> "$OUTPUT_FILE"
echo "---" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Fetch only issues that carry the deployment label (server-side filter). Previously we
# pulled every open issue and merged pages with jq --argjson, which exceeds ARG_MAX when
# the project has many issues—even if none match the label after filtering.
PER_PAGE=100
PAGE=1
while true; do
    CHUNK=$(curl -sS --fail --show-error -G --header "$AUTH_HEADER" \
        --data-urlencode "state=opened" \
        --data-urlencode "labels=$LABEL" \
        --data-urlencode "per_page=${PER_PAGE}" \
        --data-urlencode "page=${PAGE}" \
        "${API_URL}/projects/${PROJECT_ID}/issues") || exit 1
    COUNT=$(printf '%s\n' "$CHUNK" | jq 'length')
    if [ "${COUNT:-0}" -eq 0 ]; then
        break
    fi
    # Pipe each page into jq (stdin) so JSON never goes on the argv list.
    printf '%s' "$CHUNK" | jq -r --arg lbl "$LABEL" '
      .[] | select(.labels | contains([$lbl])) |
      "## [#\(.iid)] \(.title)\n\n" +
      "- **URL:** \(.web_url)\n" +
      "- **Milestone:** \(.milestone.title // "None")\n" +
      "- **Labels:** \(.labels | join(", "))\n\n" +
      "### Description\n\n\(.description // "_No description provided._")\n\n" +
      "---\n"
    ' >> "$OUTPUT_FILE"
    if [ "$COUNT" -lt "$PER_PAGE" ]; then
        break
    fi
    PAGE=$((PAGE + 1))
done

echo "✅ Success! Output saved to $OUTPUT_FILE"
