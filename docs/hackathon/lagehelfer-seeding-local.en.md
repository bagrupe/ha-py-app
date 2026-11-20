# Seed LageHelfer demo data locally

If Docker, the CMS seed, and the backend are already running per the README, all that is left for the hackathon tenant **Kooperative Regionalleitstelle Weserbergland** (KRL) is to load `seed.json` and `flaechen.geojson`. Two restarts: the backend creates structure and demo users; Bereich B creates the municipality in the CMS.

Deutsch: [lagehelfer-seeding-lokal.md](./lagehelfer-seeding-lokal.md)

## Get the seed files

Participants receive the download link and credentials separately from the event team. They are not published in this repository.

The archive must contain at least `seed.json` and `flaechen.geojson`. These files are not in the repo.

## Put them in place

Copy everything into `backend/API/Seeders/LageHelfer/Data/krl/` (create the folder if needed). Development uses the bundled example data by default. Override the path explicitly for the KRL package as shown below.

```text
backend/API/Seeders/LageHelfer/Data/krl/
├── seed.json
└── flaechen.geojson
```

Optional check that the files are there:

```bash
test -f backend/API/Seeders/LageHelfer/Data/krl/seed.json \
  -a -f backend/API/Seeders/LageHelfer/Data/krl/flaechen.geojson \
  && echo "OK" || echo "Files missing"
```

## Backend

In Development, LageHelfer is already on in `appsettings.Development.json` (`LageHelferEnabled: true`, path `example`, local demo key only). The bundled examples work without cloud access. Override the path in `backend/API/.env` to use the separately supplied KRL data. The seeder runs on every backend start and is idempotent.

If you set your own `DataSeeder__*` values in `backend/API/.env`, do not turn LageHelfer off:

```bash
DataSeeder__LageHelferEnabled=true
DataSeeder__LageHelferSeedPath=Seeders/LageHelfer/Data/krl
DataSeeder__LageHelferKeyEncryptionKey=fbqTzzZyfSPyAGBbyJZ30EMimLVpcNr+Crv8AvzHohU=
```

After copying the files, restart the backend (`task backend` or `task stop` then `task start`).

## Bereich B (content management)

In `web/bereich-b/.env` (values must match `kommune` in `seed.json`; for the KRL package):

```bash
ENABLE_LAGEHELFER_SEED=true
LAGEHELFER_KOMMUNE_ID=84a06067-dc9e-46d0-b60a-8258cf7c1ce7
LAGEHELFER_KOMMUNE_NAME=Kooperative Regionalleitstelle Weserbergland
LAGEHELFER_REGIONALSCHLUESSEL=03252
LAGEHELFER_DEFAULT_POSITION=51.9786,9.4264
```

Restart Bereich B (`task web`). The municipality is created on startup.

## Verify

- Backoffice: http://localhost:3000, demo users from `seed.json`, credentials are supplied separately by the event team

Example logins:

| Email | Role |
| :--- | :--- |
| `superadmin-krl@example.com` | Superadmin |
| `admin-krl@example.com` | District admin |
| `einsatzleitung-hameln@example.com` | Operations lead Hameln-Pyrmont |
| `einsatzleitung-holzminden@example.com` | Operations lead Holzminden |

## If something fails

**Missing or invalid `seed.json`:** Check path `.../Data/krl/` and that the archive is fully unpacked. Format: `docs/entwickler/lagehelfer-importformat.adoc`.

**`LageHelfer seeder failed` in the CMS log:** `LAGEHELFER_KOMMUNE_ID` or `LAGEHELFER_KOMMUNE_NAME` is missing or does not match `seed.json`. Copy values from the file and restart Bereich B.

**No KRL users in the backoffice:** Did you restart the backend after placing the files? Make sure `.env` does not set `DataSeeder__LageHelferEnabled=false`. Demo users are only created outside production from the `demo` section in `seed.json`.

More on the data format: `docs/entwickler/lagehelfer-seeding.adoc`, `docs/entwickler/lagehelfer-importformat.adoc`.