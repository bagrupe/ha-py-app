#!/usr/bin/env bash
# Rebuild tracked AsciiDoc outputs when docs sources are staged (via Husky pre-commit).
set -euo pipefail

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Keep in sync with Taskfile.yml docs:build docker image
DOCS_IMAGE="asciidoctor/docker-asciidoctor:1.106"

warn_skip_banner() {
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "  WARNING: AsciiDoc HTML/PDF were NOT regenerated in this commit" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
}


# Trigger: staged files under docs/ that are not only generated .html / .pdf
# (Avoid grep-in-pipeline under `pipefail`: empty matches would abort the hook.)
needs_docs_build=false
while IFS= read -r path; do
	[[ -z "$path" ]] && continue
	[[ "$path" == docs/* ]] || continue
	case "$path" in
	*.html|*.pdf) continue ;;
	esac
	needs_docs_build=true
	break
done < <(git diff --cached --name-only --diff-filter=d)

if [[ "$needs_docs_build" != "true" ]]; then
	exit 0
fi

echo "" >&2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
echo "  GENERATING DOCUMENTATION (AsciiDoctor in Docker). This may take some time…" >&2
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
echo "" >&2

if ! command -v task >/dev/null 2>&1; then
	echo "" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "  TASK CLI NOT FOUND. INSTALLING TASK CLI…" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "" >&2
	cat <<'EOF' >&2

  The Task CLI was not found. Install it first (see README.md,
  “Step 5: Install Taskfile”), for example:

    brew install go-task/tap/go-task

  Then run manually (requires Docker when your engine is running):

    task docs:build

EOF
	echo "" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "  TASK CLI NOT FOUND. INSTALLING TASK CLI…" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "" >&2
	exit 0
fi

if ! command -v docker >/dev/null 2>&1; then
	echo "" >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "  DOCKER NOT FOUND. WITHOUT DOCKER, DOCUMENTATION CANNOT BE BUILT HERE." >&2
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" >&2
	echo "" >&2
	cat <<'EOF' >&2

  Docker was not found. Without Docker, documentation cannot be built here.

  After installing Docker (or Colima) and Task, run:

    task docs:build

EOF
	exit 0
fi

if ! docker info >/dev/null 2>&1; then
	cat <<'EOF' >&2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ERROR: Docker engine is not running
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Start your Docker provider and try again. On macOS with Colima:

    colima start

  Then commit again (or run `task docs:build` first).

EOF
	exit 0
fi

if ! docker image inspect "$DOCS_IMAGE" >/dev/null 2>&1; then
	echo "" >&2
	echo "Note: The AsciiDoctor image ($DOCS_IMAGE) is not present locally yet." >&2
	echo "      Docker may download it now — this can take a while on first run." >&2
	echo "" >&2
fi

echo "" >&2
echo "Note: Building documentation (AsciiDoctor in Docker). This may take some time…" >&2
echo "" >&2

task docs:build

# Checkouts that gitignore the outputs (e.g. the public snapshot) would make `git add` fail and abort the commit.
staged_outputs=0
for output in docs/doku.html docs/doku-anwender.html docs/doku-anwender.pdf; do
	if [[ -f "$output" ]] && ! git check-ignore -q "$output"; then
		git add "$output"
		staged_outputs=$((staged_outputs + 1))
	fi
done

echo "" >&2
if [[ "$staged_outputs" -gt 0 ]]; then
	echo "Documentation outputs regenerated and staged (docs/*.html, docs/doku-anwender.pdf)." >&2
else
	echo "Documentation outputs regenerated locally; they are gitignored here, so nothing was staged." >&2
fi
