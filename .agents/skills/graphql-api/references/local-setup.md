# Local setup with LageHelfer demo data

Docker, the CMS seed and the backend run as described in the README (`task start`). Loading the KRL data (Kooperative Regionalleitstelle Weserbergland) takes two restarts: the backend creates the structure and demo users, Bereich B creates the Kommune in the CMS.

## Seed files

The event team supplies the download link and credentials separately. These files are not in the repository. Place them at:

```
backend/API/Seeders/LageHelfer/Data/krl/
├── seed.json
└── flaechen.geojson
```

## Backend

`appsettings.Development.json` enables the seeder with bundled `Data/example` data by default, without cloud access. The seeder runs on every start and is idempotent. To use the separately supplied KRL data, explicitly override the path. If `backend/API/.env` sets its own `DataSeeder__*` values, keep:

```bash
DataSeeder__LageHelferEnabled=true
DataSeeder__LageHelferSeedPath=Seeders/LageHelfer/Data/krl
DataSeeder__LageHelferKeyEncryptionKey=fbqTzzZyfSPyAGBbyJZ30EMimLVpcNr+Crv8AvzHohU=
```

Restart: `task backend`, or `task stop` then `task start`.

## Bereich B

`web/bereich-b/.env` (values must match `kommune` in `seed.json`):

```bash
ENABLE_LAGEHELFER_SEED=true
LAGEHELFER_KOMMUNE_ID=84a06067-dc9e-46d0-b60a-8258cf7c1ce7
LAGEHELFER_KOMMUNE_NAME=Kooperative Regionalleitstelle Weserbergland
LAGEHELFER_REGIONALSCHLUESSEL=03252
LAGEHELFER_DEFAULT_POSITION=51.9786,9.4264
```

Restart with `task web`; the Kommune is created on start.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `seed.json` missing or broken | Check `.../Data/krl/` and that the archive is fully extracted. Format: `docs/entwickler/lagehelfer-importformat.adoc` |
| `LageHelfer seeder failed` in the CMS log | `LAGEHELFER_KOMMUNE_ID` or `LAGEHELFER_KOMMUNE_NAME` missing or differs from `seed.json`. Copy the values, restart Bereich B. |
| No KRL users in the backoffice | Restart the backend after placing the files; `.env` must not set `DataSeeder__LageHelferEnabled=false`. Demo users are seeded outside Production only. |

Data format details: `docs/entwickler/lagehelfer-seeding.adoc`.
