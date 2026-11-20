#!/bin/bash
set -euo pipefail

if [ -z "${POSTGRES_MONITORING_PASSWORD:-}" ]; then
  echo "POSTGRES_MONITORING_PASSWORD is not set, skipping monitoring user creation"
  exit 0
fi

escaped_password="${POSTGRES_MONITORING_PASSWORD//\'/\'\'}"

psql -v ON_ERROR_STOP=1 \
  --username "${POSTGRES_USER}" \
  --dbname "${POSTGRES_DB}" <<EOSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'monitoring') THEN
    CREATE USER monitoring WITH PASSWORD '${escaped_password}';
  ELSE
    ALTER USER monitoring WITH PASSWORD '${escaped_password}';
  END IF;
END
\$\$;
GRANT pg_monitor TO monitoring;
GRANT CONNECT ON DATABASE "${POSTGRES_DB}" TO monitoring;
GRANT USAGE ON SCHEMA public TO monitoring;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO monitoring;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO monitoring;
EOSQL
