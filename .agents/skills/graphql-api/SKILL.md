---
name: graphql-api
description: Call the kommunal-app backend GraphQL API as a client (curl, scripts, a hackathon app), locally or on the hosted hackathon instance. Covers endpoints, getting a token, reading the schema, the mutation error shape and the LageHelfer (Lage, Gebiet, Einsatzleitung) operations. Not for changing the .NET schema (hotchocolate) or Payload stitching (graphql-stitching).
---

# GraphQL API (client side)

## Endpoints

| | Local | Hosted (hackathon) |
|---|---|---|
| GraphQL + Nitro UI | `http://localhost:5000/graphql` | `https://ha-py-hack.ergosign-projects.com/graphql/` |
| Backoffice | `http://localhost:3000` | `https://ha-py-hack.ergosign-projects.com/` |

Running the stack locally with the LageHelfer demo data: [references/local-setup.md](references/local-setup.md).

## Token

Every LageHelfer operation is `@authorize`. Send `Authorization: Bearer <token>`; a token is valid for 24 hours.

The `login` mutation takes a key derived from the password, not the password itself. That is why calling `login` in Nitro with the plain password fails. Two ways to get a token:

1. Log in to the backoffice with a demo user, then in the browser console: `JSON.parse(atob(sessionStorage.__ka_session)).token`.
2. Script it: [scripts/get-token.sh](scripts/get-token.sh) `<graphql-url> <email> <password>` mirrors the backoffice (`getServerLoginPassword` in `web/bereich-a/src/lib/crypto/crypto.tsx`: PBKDF2-SHA512, salt = email, 100 000 iterations, 64 bytes, base64).

Hosted demo credentials are supplied separately by the event team and must not be committed. Demo users (all with the LageHelfer permission, all scoped to the KRL Kommune):

| Email | Role |
|---|---|
| `superadmin-krl@example.com` | Superadmin |
| `admin-krl@example.com` | Admin of both Landkreise |
| `einsatzleitung-hameln@example.com` | Einsatzleitung Hameln |
| `einsatzleitung-holzminden@example.com` | Einsatzleitung Holzminden |

## Calling it

```bash
curl -s "$GRAPHQL_URL" \
  -H 'content-type: application/json' \
  -H "authorization: Bearer $TOKEN" \
  -d '{"query":"query { lagen(status: ACTIVE) { id title status } }"}' | jq
```

Mutations report domain errors in the payload: the entity is `null` and `errors` is filled, with HTTP 200. Always select:

```graphql
errors { __typename ... on Error { message } }
```

## Reading the schema

The exported SDL is `web/bereich-a/schema.graphql` (same as `app/lib/graphql/schema.graphql`). Root fields are under `type Query` and `type Mutation`; find a type with:

```bash
awk '/^(type|input|enum) Lage /,/^}/' web/bereich-a/schema.graphql
```

In Nitro: Schema → Reference, filter by type name. Ctrl+Space autocompletes fields; HTTP headers are per document.

`BereichBKommune` and other `BereichB*` types come from the Payload CMS through schema stitching; everything else is the .NET backend over Postgres.

## LageHelfer

Domain model, status lifecycle, operations, ready-to-run recipes and known issues: [references/lagehelfer.md](references/lagehelfer.md).
