# Smoke testing (How to test section)

The "How to test" section lets the reviewer see the change working (and the blockers failing) on a local stack. It is for building understanding, not a QA plan. Skip it when nothing observable changes (pure refactor, docs, CI).

## What to write

- **Setup**: only what this MR needs beyond the running stack (seed rows, config value, test user). Prefer existing skills over raw steps: `postgresql`, `mongodb`, `local-backoffice-user`, `bereich-b-authentication`.
- **Scenarios** S1..Sn, 3-6 of them:
  1. the happy path of the main change,
  2. one per Blocking C item that is reproducible by hand (the reviewer should see the failure),
  3. one per guard/refusal the ticket names.
- Each scenario: steps (exact GraphQL operation or UI path), **expected** result, how to **observe** it (response field, SQL query, log line, UI state). Reference the C/D item it demonstrates.
- Every operation name, argument and field must exist in the branch's exported schema (`app/lib/graphql/schema.graphql`); check before writing. Do not invent endpoints, ports or credentials.
- Writing the section is required when applicable; running it is not. If a scenario was run, say so with the date.

## kommunal-app toolbox (verified 2026-10-08)

| Need | How |
| --- | --- |
| Full stack | `task start` (containers + backend + web); `task containers:up` + `task backend` for backend only |
| GraphQL IDE (dev) | `http://localhost:5000/graphql` (tool enabled in Development/Staging); set `Authorization: Bearer <token>` |
| Anonymous Bürger | `registerBuergerWeak(input: {derivedPassword, publicKey, encryptedPrivateKey: {nonce, tag, cipher}, personalDataKeyForBuerger, salt})` → `buergerId`; dummy strings work for smoke tests. Then `loginBuergerWeak(input: {buergerId, password: <derivedPassword>})` → `loginPayload { result token }` |
| Registered Bürger | with the weak token: `requestSmsCode(input: {telephoneNumber})`; without a Brevo key in Development the code is only logged by the backend (`Send SMS to <hash> with Text '...'`); then `validateSmsCode(input: {telephoneNumber, validationCode})` → `token` |
| Who am I | `query { my { id } }` goes through `CurrentUserAccessor.User()` |
| Backoffice / CMS users | `admin@example.com` / `123456`; `hvb-hapy@example.com` / `123456`; create role-scoped ones with `local-backoffice-user` |
| DB inspection | `postgresql` skill (container `hameln-postgres`); app users live in the TPH table `Users` |

Keep this table current: when a scenario needs a fact not listed here, verify it in the repo and add it.
