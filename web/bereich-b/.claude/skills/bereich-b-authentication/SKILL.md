---
name: bereich-b-authentication
description: "Authenticate against bereich-b (Payload CMS v3). Covers the two distinct paths: (1) API/programmatic auth via JWT login or API key for curl/tooling/the .NET backend, and (2) browser/admin-UI auth, which is SSO-only via bereich-a (there is no native Payload login form). Also covers resetting a password in MongoDB and rotating the SuperAdmin API key the .NET backend uses. Use when something must authenticate against bereich-b, when admin-UI login fails, or when a user's password must be reset."
allowed-tools: Bash(curl *), Bash(docker *), Bash(node -e *)
model: sonnet
---

# bereich-b Authentication — Payload CMS v3

`web/bereich-b` is **Payload CMS v3** (payload `3.88.0`, Next.js 16). The
`benutzer` auth collection has `useAPIKey: true` and `useSessions: false`.

**There are two separate auth paths — do not mix them up:**

| Path | Who uses it | Mechanism |
|:-----|:------------|:----------|
| **API / programmatic** | curl, scripts, the .NET backend | JWT login endpoint **or** API-key header |
| **Browser / admin UI** | a person opening `/cms/admin` | **SSO via bereich-a only** — no Payload password form |

## Connection

- **REST base:** `http://localhost:3001/cms/api` (routes: `admin: '/cms/admin'`, `api: '/cms/api'`)
- **Admin UI:** `http://localhost:3001/cms/admin`
- **Auth collection slug:** `benutzer`
- **Super admin:** `admin@example.com` / `123456`
- **MongoDB:** container `hameln-mongodb`, URI `mongodb://admin:password@localhost:27017/bereich-b?authSource=admin`

> Collection ↔ MongoDB name mapping lives in the **bereich-b-payload-collections** skill.
> Rotating the SuperAdmin API key: [references/api-key.md](references/api-key.md).

---

## Path 1 — API / programmatic auth

The local login strategy is still enabled (no `disableLocalStrategy`), so both
methods below work for tooling even though browser users go through SSO.

### 1a. JWT login (email + password)

```bash
TOKEN=$(curl -s -X POST http://localhost:3001/cms/api/benutzer/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"123456"}' | jq -r '.token')
```

Response contains `{ "message": "Authentication Passed", "token": "<jwt>", "exp": ..., "user": {...} }`.
Then pass the JWT (note: scheme is `JWT`, not `Bearer`):

```bash
curl -s http://localhost:3001/cms/api/benutzer/me -H "Authorization: JWT $TOKEN" | jq .
```

### 1b. API key (the SuperAdmin key the .NET backend uses)

No login round-trip — send the key directly. The scheme is `<collection> API-Key`:

```bash
curl -s http://localhost:3001/cms/api/benutzer/me \
  -H "Authorization: benutzer API-Key <API_KEY>" | jq .
```

Get/rotate the key per [references/api-key.md](references/api-key.md) (`user.apiKey` on `admin@example.com`).

### Common endpoints

| Method | Endpoint | Description |
|:-------|:---------|:------------|
| GET   | `/cms/api/benutzer/me`   | Current authenticated user |
| GET   | `/cms/api/benutzer`      | List users |
| GET   | `/cms/api/benutzer/<id>` | Get user by id |
| PATCH | `/cms/api/benutzer/<id>` | Update user |
| GET   | `/cms/api/kommunen`      | List municipalities |
| GET   | `/cms/api/news-artikel`  | List news articles |
| GET   | `/cms/api/veranstaltungskalender` | List events |
| GET   | `/cms/api/pois`          | List points of interest |

Query params: `?where[field][equals]=value`, `?limit=10`, `?page=1`, `?depth=1`

---

## Path 2 — Browser / admin-UI auth (SSO via bereich-a)

**You cannot log into `/cms/admin` with a Payload password form.** The admin
`login` view is overridden in `payload.config.ts`
(`admin.components.views.login → @/components/admin/login-redirect#LoginRedirect`),
so it just redirects the browser to bereich-a:

1. Browser hits `/cms/admin` → `LoginRedirect` sends it to bereich-a's SPA route
   `/auth/login` (same origin, query string preserved, `force` added).
2. bereich-a authenticates the user against **its own** store (credentials live in
   Postgres, not Mongo).
3. bereich-a calls the internal SSO endpoint **server-to-server** to mint a Payload JWT.
4. That JWT is what establishes the admin session in the browser.

### Internal SSO endpoint

`POST /internal/sso/login` (note: **not** under `/cms`; returns the JWT as `text/plain`).

- **Body:** `{ "email": string, "bereichAUserId": string, "kommuneId"?: string|null, "type"?: string }`
- **Auth:** header `x-internal-api-secret: $INTERNAL_API_SECRET`. If `INTERNAL_API_SECRET`
  is unset the route logs a warning and relies on ingress routing alone — it is
  **not** meant to be reachable from outside the cluster.
- Mints a valid Payload JWT for any email, so it must stay internal-only.

This endpoint is for the bereich-a → bereich-b handshake. For your own scripting,
use **Path 1** instead.

---

## Reset a user's password directly in MongoDB

Useful when locked out. Payload uses **pbkdf2** with `sha256`, `25000` iterations,
`512`-byte key length — hash is **1024 hex chars**, salt **64 hex chars** (digest verified
against `payload/dist/auth/strategies/local/authenticate.js` in payload 3.88.0 —
`sha1` does NOT work). Note this only affects Path 1 password login;
browser users authenticate through bereich-a, not this hash.

```bash
node -e '
const crypto = require("crypto");
const password = "<NEW_PASSWORD>";
const salt = crypto.randomBytes(32).toString("hex");
crypto.pbkdf2(password, salt, 25000, 512, "sha256", (err, key) => {
  if (err) throw err;
  console.log(JSON.stringify({ salt, hash: key.toString("hex") }));
});
'
```

Apply it (collection is `benutzers`):

```bash
docker exec hameln-mongodb mongosh --quiet \
  "mongodb://admin:password@localhost:27017/bereich-b?authSource=admin" --eval '
db.benutzers.updateOne(
  { email: "<USER_EMAIL>" },
  { $set: { salt: "<SALT>", hash: "<HASH>" } }
)
'
```

## Your task

Based on the user's request (`$ARGUMENTS`), pick the right path: Path 1 for
scripting/tooling, Path 2 for understanding or debugging browser/admin access.
Always verify auth succeeds before dependent calls.
