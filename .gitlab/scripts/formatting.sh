#!/bin/bash

set -e # Exit on error




# Function to format and re-add staged files
format_staged_files() {
    local pattern="$1"
    local format_cmd="$2"
    local label="$3"

    # Capture staged files matching the pattern (excluding deleted files)
    # Keep two lists: full (with app/), short (without app/)
    local staged_files_full staged_files_short
    staged_files_full=$(git diff --cached --name-only --diff-filter=d | grep "$pattern" | grep '^app/' || true)
    staged_files_short=$(echo "$staged_files_full" | sed 's:^app/::' || true)

    if [ -n "$staged_files_short" ]; then
        echo "--- Formatting $label ---"

        # Run formatting command with files path without the app/ prefix
        if [[ "$format_cmd" == *"xargs"* ]]; then
            echo "$staged_files_short"
            echo "$staged_files_short" | eval "$format_cmd"
        else
            # shellcheck disable=SC2086
            $format_cmd $staged_files_short
        fi

        # Re-add the specific files to the index (must restore app/ prefix!)
        echo "$staged_files_full" | xargs git add
        echo "Successfully formatted and re-added $label files."
    else
        echo "No staged $label files detected. Skipping."
    fi
}



# 1. Mobile App (Dart)
format_staged_files '\.dart$' "cd app && xargs fvm dart format" "Dart"

# 2. Backend (.NET)
# dotnet format can take a list of files via --include
# We filter for C# files in the backend directory
STAGED_CS_FILES=$(git diff --cached --name-only --diff-filter=d | grep '^backend/.*\.cs$' || true)
if [ -n "$STAGED_CS_FILES" ]; then
    echo "--- Formatting Backend (.NET) ---"
    # dotnet format needs the project or solution file.
    # We use --include to specify only the staged files.
    # We convert the list of files to a space-separated string for --include
    FILES_TO_INCLUDE=$(echo "$STAGED_CS_FILES" | tr '\n' ' ')
    dotnet format backend/backend.sln --include $FILES_TO_INCLUDE

    echo "$STAGED_CS_FILES" | xargs git add
    echo "Successfully formatted and re-added Backend files."
else
    echo "No staged Backend (.NET) files detected. Skipping."
fi

# 3. Web Projects (Prettier)
# We use the root web package.json prettier:fix which uses turbo
# However, for pre-commit we want to be surgical.
# We'll use prettier directly if available or pnpm exec prettier
STAGED_WEB_FILES=$(git diff --cached --name-only --diff-filter=d | grep -E '^web/.*\.(js|ts|jsx|tsx|vue|css|scss|json|md|graphql|gql)$' || true)
if [ -n "$STAGED_WEB_FILES" ]; then
    echo "--- Formatting Web Projects (Prettier) ---"
    # Run prettier from the web directory
    cd web && pnpm prettier:fix && cd ..
    echo "$STAGED_WEB_FILES"
    echo "$STAGED_WEB_FILES" | xargs git add
    echo "Successfully formatted and re-added Web files."
else
    echo "No staged Web files detected. Skipping."
fi
