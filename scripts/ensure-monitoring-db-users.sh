#!/usr/bin/env bash
# Ensures read-only monitoring users exist in Postgres and MongoDB.
# Idempotent — safe to run on every deploy and on existing databases.

set -euo pipefail

POSTGRES_CONTAINER="${POSTGRES_CONTAINER:-hameln-postgres}"
MONGO_CONTAINER="${MONGO_CONTAINER:-hameln-mongodb}"

container_env() {
  local container="$1"
  local key="$2"
  docker exec "$container" printenv "$key" 2>/dev/null | tr -d '\r' || true
}

ensure_postgres_monitoring_user() {
  if [ -z "${POSTGRES_MONITORING_PASSWORD:-}" ]; then
    echo "POSTGRES_MONITORING_PASSWORD is not set, skipping Postgres monitoring user"
    return 0
  fi

  if ! docker ps --format '{{.Names}}' | grep -qx "$POSTGRES_CONTAINER"; then
    echo "Postgres container '$POSTGRES_CONTAINER' is not running, skipping"
    return 0
  fi

  local postgres_user postgres_db
  postgres_user="${POSTGRES_USER:-$(container_env "$POSTGRES_CONTAINER" POSTGRES_USER)}"
  postgres_db="${POSTGRES_DB:-$(container_env "$POSTGRES_CONTAINER" POSTGRES_DB)}"

  if [ -z "$postgres_user" ] || [ -z "$postgres_db" ]; then
    echo "Could not resolve POSTGRES_USER or POSTGRES_DB"
    exit 1
  fi

  local escaped_password="${POSTGRES_MONITORING_PASSWORD//\'/\'\'}"
  docker exec -i "$POSTGRES_CONTAINER" psql -v ON_ERROR_STOP=1 \
    --username "$postgres_user" \
    --dbname "$postgres_db" <<EOSQL
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
GRANT CONNECT ON DATABASE "${postgres_db}" TO monitoring;
GRANT USAGE ON SCHEMA public TO monitoring;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO monitoring;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO monitoring;
EOSQL

  echo "Postgres monitoring user ensured"
}

ensure_mongo_monitoring_user() {
  if [ -z "${MONGO_MONITORING_PASSWORD:-}" ]; then
    echo "MONGO_MONITORING_PASSWORD is not set, skipping MongoDB monitoring user"
    return 0
  fi

  if ! docker ps --format '{{.Names}}' | grep -qx "$MONGO_CONTAINER"; then
    echo "MongoDB container '$MONGO_CONTAINER' is not running, skipping"
    return 0
  fi

  local mongo_root_user mongo_root_password
  mongo_root_user="${MONGO_INITDB_ROOT_USERNAME:-$(container_env "$MONGO_CONTAINER" MONGO_INITDB_ROOT_USERNAME)}"
  mongo_root_password="${MONGO_INITDB_ROOT_PASSWORD:-$(container_env "$MONGO_CONTAINER" MONGO_INITDB_ROOT_PASSWORD)}"

  if [ -z "$mongo_root_user" ] || [ -z "$mongo_root_password" ]; then
    echo "Could not resolve MongoDB root credentials"
    exit 1
  fi

  local escaped_password="${MONGO_MONITORING_PASSWORD//\'/\\\'\'}"
  docker exec -i "$MONGO_CONTAINER" mongosh \
    -u "$mongo_root_user" \
    -p "$mongo_root_password" \
    --authenticationDatabase admin <<EOF
const adminDb = db.getSiblingDB('admin');
const monitoringUser = {
  user: 'monitoring',
  pwd: '${escaped_password}',
  roles: [
    { role: 'clusterMonitor', db: 'admin' },
    { role: 'read', db: 'local' }
  ]
};

if (adminDb.getUser('monitoring')) {
  adminDb.updateUser('monitoring', monitoringUser);
} else {
  adminDb.createUser(monitoringUser);
}
EOF

  echo "MongoDB monitoring user ensured"
}

ensure_postgres_monitoring_user
ensure_mongo_monitoring_user
