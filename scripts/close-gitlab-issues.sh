#!/bin/bash
#
# -----------------------------------------------------------------------------
# Documentation
#
# This script clears all assignees from open GitLab issues in a given project
# that are labeled with a specified column label (e.g., "Ready4DeploymentProd"),
# and prepares them for further automation (e.g., closing, release, etc.).
#
# The script requires a valid GitLab API token for authentication.
#
# Environment Variables (can be exported or provided inline):
#
#   API_TOKEN        - (required) Personal access token or CI_JOB_TOKEN with
#                      permission to edit issues in the target project.
#   CI_PROJECT_ID    - (optional) GitLab project ID to act on (default: 1244).
#   CI_COLUMN_LABEL  - (optional) Issue label/column to target
#                      (default: "Ready4DeploymentProd").
#
# Example usage:
#   export API_TOKEN="your_token_here"
#   ./scripts/close-gitlab-issues.sh
#
#   # Or run one-off with temporary env vars:
#   CI_COLUMN_LABEL="QA Review" API_TOKEN="your_token_here" ./scripts/close-gitlab-issues.sh
#
# Dependencies:
#   - curl
#   - jq
#
# -----------------------------------------------------------------------------



# --- CONFIGURATION ---
GITLAB_URL="https://gitlab.example.invalid"
PRIVATE_TOKEN="${API_TOKEN:-}"
PROJECT_ID="${CI_PROJECT_ID:-1244}"
COLUMN_LABEL="${CI_COLUMN_LABEL:-"Ready4DeploymentProd"}"
# ---------------------

echo "Fetching open issues with label: '$COLUMN_LABEL'..."

# 1. Fetch the list of issues
ISSUES_JSON=$(curl --silent --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
    "$GITLAB_URL/api/v4/projects/$PROJECT_ID/issues?labels=$(echo $COLUMN_LABEL | sed 's/ /%20/g')&state=opened&per_page=100")

# 2. Extract IIDs
ISSUE_IIDS=$(echo "$ISSUES_JSON" | jq -r '.[].iid')

if [ -z "$ISSUE_IIDS" ] || [ "$ISSUE_IIDS" == "null" ]; then
    echo "No issues found in that column."
    exit 0
fi
ISSUE_COUNT=$(echo "$ISSUE_IIDS" | wc -w)
echo "Found total of $ISSUE_COUNT issues to clear"
echo "Found issues. Clearing all assignees..."

# 3. Loop and Clear
for IID in $ISSUE_IIDS; do
    # Passing assignee_ids[] with no value clears the list

    # Check if the issue has an assignee
    HAS_ASSIGNEE=$(curl --request GET --silent --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
        "$GITLAB_URL/api/v4/projects/$PROJECT_ID/issues/$IID" | jq -r '.assignees')

    if [ "$HAS_ASSIGNEE" == "[]" ]; then
        echo "Issue #$IID has no assignee. Skipping..."
        continue
    fi  # Issue has no assignee

    RESPONSE=$(curl --request PUT --silent --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
        "$GITLAB_URL/api/v4/projects/$PROJECT_ID/issues/$IID?assignee_ids[]=0")
    HAS_ASSIGNEE=$(echo "$RESPONSE" | jq -r '.assignees')
    if [ "$HAS_ASSIGNEE" != "[]" ]; then
        echo "Failed to clear Issue #$IID"
        exit 1
    fi
    echo "Issue #$IID assignee cleared"
done


# 4. Close the issue
for IID in $ISSUE_IIDS; do
    # Check if the issue is already closed
    IS_CLOSED=$(curl --request GET --silent --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
        "$GITLAB_URL/api/v4/projects/$PROJECT_ID/issues/$IID" | jq -r '.state')
    if [ "$IS_CLOSED" == "closed" ]; then
        echo "Issue #$IID is already closed. Skipping..."
        continue
    fi
    # Close the issue
    RESPONSE=$(curl --request PUT --silent --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
        "$GITLAB_URL/api/v4/projects/$PROJECT_ID/issues/$IID?state_event=close")
    echo "Closed Issue #$IID"
done

echo "Batch update complete. $ISSUE_COUNT issues cleared and closed."
