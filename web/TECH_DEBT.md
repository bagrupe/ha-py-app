# Technical Debt -- Dependency Vulnerabilities

**Audit snapshot (2026-02-27):** 54 findings (2 critical, 25 high, 14 moderate, 13 low).
All remaining vulnerabilities are transitive and blocked on upstream major upgrades.
Safe patch-level upgrades have already been applied.

---

## 1. Payload CMS v1 -> v3

**What:** `payload@1.15.12` in bereich-b pulls in outdated transitive dependencies
that account for roughly 39 of the 54 audit findings (73%).

**Affected transitives (selection):**

| Package | Pinned | Patched at | Severity |
|---------|--------|------------|----------|
| mongoose | 6.11.4 | >=6.13.5 | critical (CVE-2025-23061), high (CVE-2024-53900) |
| sharp | 0.31.3 | >=0.32.6 | high (CVE-2023-4863) |
| webpack | 5.88.2 | >=5.94.0 | moderate (CVE-2024-43788), low (CVE-2025-68458, CVE-2025-68157) |
| webpack-dev-middleware | 6.0.1 | >=6.1.2 | high (CVE-2024-29180) |
| nodemailer | 6.9.4 | >=7.0.11 | high (CVE-2025-14874), moderate (CVE-2025-13033) |
| mongodb | 4.16.0 | >=4.17.0 | moderate (CVE-2021-32050) |
| ip | 2.0.0 | none | high (CVE-2024-29415), low (CVE-2023-42282) |
| tar-fs | 2.1.1 | >=2.1.4 | high (3 CVEs) |
| path-to-regexp | 1.8.0 | >=1.9.0 | high (CVE-2024-45296) |
| qs | 6.13.0 | >=6.14.1 | high (CVE-2025-15284), low (CVE-2026-2391) |
| serialize-javascript | 6.0.1 | >=6.0.2 | moderate (CVE-2024-11831) |
| diff | 4.0.2, 5.1.0 | >=4.0.4, >=5.2.2 | low (CVE-2026-24001) |
| on-headers | 1.0.2 | >=1.1.0 | low (CVE-2025-7339) |
| es5-ext | 0.10.62 | >=0.10.63 | low (CVE-2024-27088) |
| fast-xml-parser | 5.3.6 | >=5.3.8 | low (CVE-2026-27942) |
| payload (itself) | 1.15.12 | >=3.44.0+ | moderate (CVE-2025-4644, CVE-2025-4643, CVE-2026-25574, CVE-2026-27567) |

Also pulls `react-router-dom@5.3.4` transitively, contributing to the
`path-to-regexp@1.8.0` high advisory. bereich-b has a direct `react-router@5`
dependency as well (used in `use-list-view-refresh-hack.ts` to interface with
Payload's admin UI router).

**Why blocked:** Payload v3 is a full rewrite (new data layer, new admin UI,
dropped Express for its own server). Migration requires rewriting all Payload
collections, hooks, access-control, and the custom admin components in bereich-b.

**Possible solutions:**

- Plan and execute the Payload v1 -> v3 migration as a dedicated project.
- As a short-term mitigation, use `pnpm.overrides` to force-bump individual
  transitive packages where the override does not break Payload at runtime
  (e.g., `qs`, `on-headers`, `serialize-javascript`). Each override must be
  tested individually.

---

## 2. @graphql-codegen v5 -> v6

**What:** `@graphql-codegen/cli@5.0.7` and related packages in bereich-a pull
in 7 advisories through outdated transitives.

**Affected advisories:**

| Package | Pinned | Severity | CVE |
|---------|--------|----------|-----|
| minimatch | 3.1.2 (339 paths via @ardatan/relay-compiler) | high | CVE-2026-26996, CVE-2026-27903, CVE-2026-27904 |
| ws | 8.13.0 (via executor-legacy-ws) | high | CVE-2024-37890 |
| dset | 3.1.2 (175 paths via @graphql-tools/utils) | high | CVE-2024-21529 |
| jose | 4.14.4 (via @graphql-tools/prisma-loader) | moderate | CVE-2024-28176 |
| tmp | 0.0.33 (via inquirer) | low | CVE-2025-54798 |
| brace-expansion | 1.1.11 (392 paths) | low | CVE-2025-5889 |

**Why blocked:** `@atmina/local-typescript-operations@0.9.0` declares
`peerDependencies: { "@graphql-codegen/near-operation-file-preset": "^2.5.0" }`.
The v6 upgrade requires `near-operation-file-preset@4.0.0`, which is outside
that peer range. `0.9.0` is the latest published version of the @atmina package.

**Possible solutions:**

- Fork or contribute a PR to `@atmina/local-typescript-operations` to widen the
  peer dep to include `near-operation-file-preset@^4.0.0`.
- Use `pnpm.peerDependencyRules.allowedVersions` to suppress the peer warning
  and test whether the plugin works with the new preset without code changes.
- Replace `@atmina/local-typescript-operations` with an alternative approach if
  graphql-codegen v6 provides equivalent functionality natively.

---

## 3. @sentry/vite-plugin v2 -> v3+

**What:** `@sentry/vite-plugin@2.16.1` in bereich-a contributes 2 advisories
through its `glob@9.3.2` dependency.

**Affected advisories:**

| Package | Pinned | Severity | CVE |
|---------|--------|----------|-----|
| minimatch | 7.4.6 (via glob@9.3.2) | high | CVE-2026-26996, CVE-2026-27903, CVE-2026-27904 |
| brace-expansion | 2.0.1 (via minimatch) | low | CVE-2025-5889 |

**Why blocked:** Major version upgrade. The v3 plugin may have breaking changes
in configuration or Vite compatibility.

**Possible solutions:**

- Attempt the upgrade to `@sentry/vite-plugin@3.x` and test the Sentry source
  map upload pipeline.
- Use `pnpm.overrides` to force `minimatch@>=7.4.8` under the v2 plugin and
  verify it does not break glob behavior.

---

## 4. osmtogeojson / @xmldom/xmldom

**What:** `osmtogeojson@3.0.0-beta.5` in bereich-b depends on
`@xmldom/xmldom@0.8.3`, which has a critical vulnerability.

**Advisory:** GHSA-crh6-fp67-6883 / CVE-2022-39353 -- xmldom allows multiple
root nodes in a DOM. Patched in `@xmldom/xmldom@>=0.8.4`.

**Why blocked:** `osmtogeojson` has not released a version that bumps
`@xmldom/xmldom` above `0.8.3`. The package is on a `3.0.0-beta.5` prerelease
with no stable release or newer beta available.

**Possible solutions:**

- Use `pnpm.overrides` to force `@xmldom/xmldom@>=0.8.4` and test that
  osmtogeojson still parses OSM XML correctly.
- Fork osmtogeojson, bump the xmldom dependency, and point to the fork.
- Evaluate alternative OSM-to-GeoJSON libraries.

---

## 5. @tanstack/react-query 5.66 -> 5.90

**What:** `@tanstack/react-query@5.66.9` (bereich-b) and its transitive
`@tanstack/query-core@5.66.4` are pinned at their current versions due to an
existing pnpm patch.

**Patch file:** `patches/@tanstack__query-core@5.66.4.patch`
Guards `this.#cleanup?.()` inside `setEventListener()` in `focusManager.js` and
`onlineManager.js` to prevent calling cleanup when it is not set.

**Why blocked:** The patch is version-pinned to `@tanstack/query-core@5.66.4`.
Upgrading to `5.90.x` (24 minor versions ahead) would invalidate the patch
because the build output it targets will have changed.

**Possible solutions:**

- Check whether the upstream bug the patch addresses has been fixed in
  `query-core@5.90.x`. If so, drop the patch and upgrade.
- If the bug persists upstream, regenerate the patch against the new version's
  build output.
- File an upstream issue or PR on `@tanstack/query-core` for the cleanup guard.

---

## 6. lodash in e2e

**What:** `e2e/package.json` lists `lodash@4.17.21` as a direct dependency.
Version `4.17.23` fixes a prototype pollution vulnerability in `_.unset` and
`_.omit`.

**Advisory:** GHSA-xxjr-mmjv-4gpg / CVE-2025-13465 (moderate).
Patched in `lodash@>=4.17.23`.

**Why blocked:** The e2e workspace was out of scope for the patch-level upgrade
session that covered bereich-a and bereich-b. The upgrade itself is a simple
version bump but requires verifying that e2e tests still pass.

**Possible solutions:**

- Bump `lodash` to `4.17.23` in `e2e/package.json` and run the Playwright test
  suite.
- Evaluate whether lodash can be replaced with native JS in the e2e helpers to
  remove the dependency entirely.
