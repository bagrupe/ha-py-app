#!/usr/bin/env bash

REPORTS_DIR="${1}"
if [[ $# -lt 1 ]]; then
    echo >&2 "You have to provide the directory containing your coverage reports."
    exit 2
fi

total_coverage=0
count=0

# find and process reports
while IFS= read -r i; do
    printf "Found coverage report: %s\n" "$i"

    # Extract line-rate (e.g., 0.85)
    line_rate=$(head -n 2 "$i" | sed 'N;s/.*line-rate="\([^" ]*\).*/\1/g')

    # Calculate coverage using awk instead of bc
    coverage=$(awk -v lr="$line_rate" 'BEGIN {print lr * 100}')
    printf "PARTIAL_COVERAGE: %2.2f\n" "$coverage"

    count=$((count + 1))
    total_coverage=$(awk -v tot="$total_coverage" -v cov="$coverage" 'BEGIN {print tot + cov}')
done < <(find "$REPORTS_DIR" -name '*.xml')

if [ "$count" -eq 0 ]; then
    echo "No reports found."
    exit 1
fi

# Final average calculation
final_avg=$(awk -v tot="$total_coverage" -v cnt="$count" 'BEGIN {print tot / cnt}')

printf "Found a total of %i report(s)\n" "$count"
printf "TOTAL_COVERAGE=%2.2f\n" "$final_avg"
