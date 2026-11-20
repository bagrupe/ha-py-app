---
name: local-backoffice-user
description: >
  Use when creating or updating a local Bereich A backoffice test user directly
  from the backend/API workspace, including role-scoped users (Art, global
  permissions, per-Untereinheit permissions, Dienstleister, groups) with a valid
  password hash and crypto fields. Provides a deterministic script that inserts
  or updates the user through EF Core without using the web UI.
---

# Local Bereich A Backoffice User

Use `.claude/skills/local-backoffice-user/scripts/create-local-backoffice-user.sh` from `backend/API` when a local developer needs a usable Bereich A backoffice login.

The script creates or updates a `BackofficeUser` with:

- ASP.NET password hash for the frontend-derived login password
- personal RSA keypair fields (`PublicKey`, `PersonalPrivateKey`, `PersonalPrivateKeySalt`)
- `OrganisationPrivateKey` encrypted for that user
- `Art` (default `Superadmin`, set with `--art`)
- optional role scoping (see below)
- cleared invitation / pending-confirmation fields

## Command

```bash
./.claude/skills/local-backoffice-user/scripts/create-local-backoffice-user.sh \
  --email local-superadmin@example.com \
  --password 123456 \
  --first-name Local \
  --last-name Superadmin
```

Defaults:

- connection string: `Server=127.0.0.1;Port=5432;Database=db;UserId=admin;Password=password;Enlist=false`
- kommune: `KommuneSeeder.LandkreisHaPy`
- group copy source: `superadmin-hapy@example.com`

Set a different DB with `--connection-string` or `KOMMUNALAPP_DOMAIN_CONNECTION`.

## Role-scoped users

```bash
./.claude/skills/local-backoffice-user/scripts/create-local-backoffice-user.sh \
  --email user.nutzer@test.de --password password12345 --art Nutzer \
  --global-permission ArchivEinsicht \
  --unit "Hameln=BackofficeAntraege,InhaltspflegeNewsArtikel" \
  --group "Bauamt"
```

- `--art Nutzer|Admin|Superadmin|Dienstleister`
- `--global-permission NAME` (repeatable): `GlobaleFunktionsberechtigung`. Replaces the user's global permissions.
- `--unit "Untereinheit=PERM,PERM"` (repeatable): `FunktionsberechtigungInOrganisationseinheit` per Untereinheit name; `*` grants all. Replaces the user's unit permissions.
- `--dienstleister NAME`: links the user to that Dienstleister, creating it in the local kommune if missing. Use with `--art Dienstleister`.
- `--group NAME` (repeatable): existing `MitarbeiterGruppe`; when given, `--copy-groups-from` is skipped.
- Unknown enum names or Untereinheit/group names fail with the valid values listed. Permissions are not checked against each permission's minimum `Art`.

## Notes

- This is for local development data only. Do not use it for shared, staging, or production databases.
- The script references `API.csproj` and runs a temporary C# helper so it stays aligned with the current EF model.
- Bereich B/Payload sync is not forced by this script. If the user must exist in Bereich B too, use the app's normal synchronizer path after creating the Bereich A user.
