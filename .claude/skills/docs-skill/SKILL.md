---
name: docs-skill
description: Workflow for adding, building, and verifying AsciiDoc documentation in the kommunal-app docs/ directory. Use when asked to add a new documentation page, update existing docs, build the docs, or verify compiled output. Covers the docs/ structure, include patterns, build command, and output verification.
---

# AsciiDoc Documentation Workflow

## Structure

```
docs/
├── doku.adoc              # Master doc (full: intro + features + install + user manual + developer docs)
├── doku-anwender.adoc     # Standalone user manual only
├── einleitung.adoc        # Introduction chapter
├── features.adoc          # Features chapter
├── anwender/
│   ├── backoffice/        # Backoffice user manual pages
│   └── inhaltspflege/     # CMS content management pages
├── entwickler/            # Developer documentation pages
├── installation/          # Installation and operational requirements
└── assets/anwender/       # Screenshots and GIFs referenced by pages
```

Compiled outputs (committed to repo): `doku.html`, `doku-anwender.html`, `doku-anwender.pdf`.  
`doku.pdf` is excluded from the build task (OOM on the full doc).

## Adding a New Page

1. Create a `.adoc` file in the appropriate subdirectory (`anwender/backoffice/`, `anwender/inhaltspflege/`, `entwickler/`, or `installation/`).

2. Add an `include::` directive in the relevant master doc(s):
   - `doku.adoc` — always, for the full documentation
   - `doku-anwender.adoc` — only if it belongs in the user manual

   Follow the existing ordering in the master doc. Example:
   ```adoc
   include::anwender/backoffice/my-new-page.adoc[]
   ```

3. New pages use standard AsciiDoc section headings (`===`, `====`) — never `==` or `=` (those are reserved for master doc chapters).

4. Place any images in `assets/anwender/` and reference them with:
   ```adoc
   image::assets/anwender/MyScreenshot.png[Alt text]
   ```

## AsciiDoc Conventions in This Project

- Author line: `ATMINA Solutions GmbH & Ergosign GmbH`
- Date line: `Stand {localdate}` (auto-resolved at compile time — never hardcode a date)
- These appear only in the master doc headers, not in individual page files.

## Building

```bash
task docs:build
```

Runs a single `asciidoctor/docker-asciidoctor` container (requires Docker). Compiles:
- `doku.adoc` → `doku.html`
- `doku-anwender.adoc` → `doku-anwender.html` + `doku-anwender.pdf`

## Verifying Output

After building, confirm the compiled files are fresh and correct:

```bash
# Check timestamps — all three should reflect today
ls -lh docs/*.html docs/doku-anwender.pdf

# Confirm author and date resolved correctly in HTML
grep -m3 "ATMINA\|Ergosign\|Stand" docs/doku.html docs/doku-anwender.html
```

Expected output contains:
- `ATMINA Solutions GmbH &amp; Ergosign GmbH`
- `Stand <today's date in YYYY-MM-DD format>`

If a newly added page is missing from the output, the `include::` directive was likely omitted or has a typo in the path.

## Committing

After verifying, commit both the `.adoc` source files and the compiled `.html`/`.pdf` outputs together. Developers build locally and commit the outputs — there is no CI job for this.
