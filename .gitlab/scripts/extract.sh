#!/bin/bash

# Check if a filename was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_markdown_file>"
    exit 1
fi

INPUT_FILE=$1

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

echo "### Newest Release - Issue Summary"
echo ""

# Parse the file using awk
# 1. Look for lines starting with '## [#' to get the title
# 2. Look for lines starting with '- **URL:**' to get the link
# 3. Clean up the text and format as a Markdown list
awk '
/^## \[#/ {
    # Extract everything after the first space following the ID bracket
    title = $0;
    sub(/^## /, "", title);
    next;
}
/^- \*\*URL:\*\*/ {
    url = $3;
    # Print the formatted markdown item once both pieces are found
    if (title != "") {
        printf "* [%s](%s)\n", title, url;
        title = ""; # Reset for next item
    }
}' "$INPUT_FILE"
