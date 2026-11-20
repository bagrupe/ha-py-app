# CLAUDE.md

## Project Overview

Kommunal-App (HaPy App) is a municipal digital ecosystem for Hameln-Pyrmont. It consists of five main components (app, backend, bereich-a, bereich-b, stele) that communicate primarily via GraphQL.


## Monorepo Structure

- Root uses [go-task](https://taskfile.dev) (`Taskfile.yml`) for orchestration
- `web/` is a **pnpm 9.15.9** workspace with **Turbo 2** for build orchestration
- Node version: **22.14.0** (see `.nvmrc`)
- Workspaces: `bereich-a`, `bereich-b`, `stele`, `email-templates`, `e2e`, and the shared libraries under `packages/*`
- app/ flutter app
- backend/ .NET backend

## Common Commands

### Full stack (from repo root)

```bash
task start          # Docker containers + backend + web (all parallel)
task stop           # Stop everything
task containers:up  # Just Docker (Postgres, Mongo, Gotenberg)
task containers:down
task db:update      # Import database dump from Nextcloud
task commit         # Interactive commit with commitlint
```



## Commit Convention

Commits must follow [Conventional Commits](https://www.conventionalcommits.org/) enforced by commitlint + husky:

```
<type>(<scope>): <description>

Changelog: <added|fixed|changed|deprecated|removed|security|performance|documentation|dependencies|other>
```

- A commit message is the subject line plus the required `Changelog:` trailer (blank line before it); no body.
- **Types:** feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- **Scopes (required):** app, backend, bereich-a, bereich-b, stele, shared, infrastructure, monitoring
- Header max 100 characters

## Writing Code in this codebase
This codebase is contributed on by bilingual contributors (German/English). I speak english!

- Name variables in English unless the name describes a domain-specific concept.
- Don't write comments that narrate what the code does. Express it in the names instead — a comment that restates the line below it goes stale and adds nothing.
- Comment only to record something the code cannot say: a non-obvious constraint, a gotcha, a required header. Two sentences is already long.
