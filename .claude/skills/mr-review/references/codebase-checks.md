# kommunal-app recurring checks

Seed C-items from these when the change touches the area. Each line is a known pitfall in this repo; verify against `main` before relying on it.

## Backend (.NET, `backend/API`)

- **Soft delete is manual.** No `HasQueryFilter`; every query filters `IsDeleted` / `GeloeschtAm` by hand. New soft-deleted rows must be excluded everywhere they can surface (queries, lookups, merges).
- **`CurrentUserAccessor.User()` does not check `IsDeleted`** (only `EnsureBackofficeUser` does). Anything that deactivates a user must make old tokens useless; SMS-login JWTs live 1 day (`LoginMutation.cs`), BundID strong tokens 15 min.
- **FK delete behaviour.** Check `OnDelete` in the entity config and `Migrations/DomainContextModelSnapshot.cs`; Restrict FKs make hard deletes fail, Cascade FKs delete silently.
- **Unique indexes on hashes** (e.g. `Buerger.PhoneHash`, `ExternalIdentity` subject hash) block re-use of the same value by a new row.
- **Typed errors**: `[UseMutationConvention]` + `[Error(typeof(X))]`, exceptions derive from `DomainException`. Any refusal outside the union surfaces as an untyped error.
- **DbContext in resolvers**: inject `DomainContext` directly; `IDbContextFactory` only inside `[DataLoader]`.
- **Model change ⇒ migration** with regenerated `DomainContextModelSnapshot.cs`; data migrations idempotent with a working `Down`.
- **Tunables configurable**: limits, thresholds, timeouts read from options with a default, never a literal.
- **Push**: tokens live in `Buerger.PushNotificationTokens` and are subscribed to Firebase topics (`PushTopic`). Clearing the DB list does not unsubscribe the device; use `IFirebasePushMessagingService`. Tests use `RecordingFirebasePushMessagingService`.
- **Personal data**: plaintext PII on `Buerger` plus encrypted `Phone`/`PersonalData`; free text (`Nachricht`, `Note`, descriptions, addresses) is personal data too.
- **Shared-code extraction**: when logic moves into a shared helper, check every existing caller still behaves as on `main` and that the old private copy is removed.

## Schema and clients

- Schema change ⇒ exported to `app/lib/graphql/schema.graphql`, `web/bereich-a/schema.graphql`, `web/stele/schema.graphql`, and codegen regenerated (app `__generated__`, bereich-a/stele `introspection.ts`).
- Enum additions: clients must tolerate the new value (Dart `$unknown`, TS switch exhaustiveness).

## Repo hygiene

- Rebuilt generated docs (`docs/*.pdf`, `docs/doku*.html`) with only date changes are churn; ask to drop them.
- Code: no narration comments, English identifiers except domain terms, test names in English.
- Docs (`docs/**/*.adoc`) describe current behaviour only: no plans, gaps or "doesn't do" sections.
- Commits: Conventional Commits with required scope (`app`, `backend`, `bereich-a`, `bereich-b`, `stele`, `shared`, `infrastructure`).

## Tests

- Always `task backend:reset-test-db` and `pg_isready` before `CI=true dotnet test`; failures on a dirty DB are phantom.
- Baseline is fully green; a red test is never "pre-existing" without a clean-DB reproduction.
