#!/bin/bash

# Expected Version Pattern: x.y.z+n (e.g., 1.0.4+32)
# where x, y, z are semantic version numbers and n is the build number.
VERSION_PATTERN='^[vV]?[0-9]+\.[0-9]+\.[0-9]-(\+[0-9]+)?$'

set -e

# Check if PUBSPEC_PATH is set
if [ -z "$PUBSPEC_PATH" ]; then
  echo "Error: PUBSPEC_PATH environment variable is not set."
  exit 1
fi

# Check if the file exists
if [ ! -f "$PUBSPEC_PATH" ]; then
  echo "Error: pubspec.yaml not found at $PUBSPEC_PATH"
  exit 1
fi

# Extract version from pubspec.yaml
# Assumes 'version: x.y.z+n' format
VERSION=$(grep '^version:' "$PUBSPEC_PATH" | sed 's/version: //g' | tr -d '[:space:]')

if [ -z "$VERSION" ]; then
  echo "Error: Could not extract version from $PUBSPEC_PATH"
  exit 1
fi

echo "Current version in pubspec.yaml: $VERSION"

# Fetch all tags
git fetch --tags

# Get list of existing tags
# We filter tags that look like versions to avoid noise
TAGS=$(git tag -l | grep -E "$VERSION_PATTERN" || true)

if [ -z "$TAGS" ]; then
  echo "No existing version tags found. This version ($VERSION) is valid as the first one."
  exit 0
fi

# Check if exact version already exists
if echo "$TAGS" | grep -q -E "^v?$VERSION$"; then
  echo "Error: Version $VERSION already exists as a tag."
  exit 1
fi

# Function to compare versions
# Returns 1 if $1 > $2, 2 if $1 < $2, 0 if equal
version_gt() {
    # Remove leading 'v' if present
    local v1=${1#v}
    local v2=${2#v}

    # Split into version and build number
    local ver1=${v1%+*}
    local build1=${v1#*+}
    if [[ "$v1" != *+* ]]; then build1=0; fi

    local ver2=${v2%+*}
    local build2=${v2#*+}
    if [[ "$v2" != *+* ]]; then build2=0; fi

    # Compare semantic version parts (major.minor.patch)
    IFS='.' read -ra VER1 <<< "$ver1"
    IFS='.' read -ra VER2 <<< "$ver2"

    for i in 0 1 2; do
        local n1=${VER1[i]:-0}
        local n2=${VER2[i]:-0}
        if (( n1 > n2 )); then return 1; fi
        if (( n1 < n2 )); then return 2; fi
    done

    # If semantic versions are equal, compare build numbers
    if (( build1 > build2 )); then return 1; fi
    if (( build1 < build2 )); then return 2; fi

    return 0
}

# Find the highest existing tag
HIGHEST_TAG=""
for TAG in $TAGS; do
    if [ -z "$HIGHEST_TAG" ]; then
        HIGHEST_TAG=$TAG
    else
        version_gt "$TAG" "$HIGHEST_TAG"
        if [ $? -eq 1 ]; then
            HIGHEST_TAG=$TAG
        fi
    fi
done

echo "Highest existing tag: $HIGHEST_TAG"

# Compare current version with highest tag
version_gt "$VERSION" "$HIGHEST_TAG"
RESULT=$?

if [ $RESULT -eq 1 ]; then
    echo "Success: Version $VERSION is greater than $HIGHEST_TAG"
    exit 0
else
    echo "Error: Version $VERSION is not greater than $HIGHEST_TAG"
    exit 1
fi
