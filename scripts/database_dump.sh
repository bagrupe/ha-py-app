#!/usr/bin/env bash
# Creates database dumps for the postgres (domain), postgres-archive, and mongodb databases.

# Exit immediately if a command exits with a non-zero status
set -e

TARGET_DIR=$1
cd "$TARGET_DIR" || exit 1

POSTGRES_CONTAINER_NAME="hameln-postgres"
POSTGRES_ARCHIVE_CONTAINER_NAME="hameln-postgres-archive"
MONGO_CONTAINER_NAME="hameln-mongodb"
DATE=$(date "+%Y%m%d")

# Postgres Dump
if docker ps --format '{{.Names}}' | grep -q "$POSTGRES_CONTAINER_NAME"; then
    echo "🐘 Dumping Postgres..."
    # We wrap the command in 'sh -c' so the container evaluates its own ENV variables
    docker exec $POSTGRES_CONTAINER_NAME sh -c 'pg_dump -U ${POSTGRES_USER:-postgres} -Fc ${POSTGRES_DB}' > "${DATE}-postgres.dump"

    # Verify the file isn't empty
    if [ ! -s "${DATE}-postgres.dump" ]; then echo "❌ Postgres dump failed or is empty"; exit 1; fi
else
    echo "❌ ERROR: Container '$POSTGRES_CONTAINER_NAME' is not running!"
    docker ps --format "table {{.Names}}\t{{.Status}}" # Print what IS running for debugging
fi

# Postgres Archive Dump
if docker ps --format '{{.Names}}' | grep -q "$POSTGRES_ARCHIVE_CONTAINER_NAME"; then
    echo "🐘 Dumping Postgres Archive..."
    docker exec $POSTGRES_ARCHIVE_CONTAINER_NAME sh -c 'pg_dump -U ${POSTGRES_USER:-postgres} -Fc ${POSTGRES_DB:-archive}' > "${DATE}-postgres-archive.dump"

    if [ ! -s "${DATE}-postgres-archive.dump" ]; then echo "❌ Postgres archive dump failed or is empty"; exit 1; fi
else
    echo "❌ ERROR: Container '$POSTGRES_ARCHIVE_CONTAINER_NAME' is not running!"
    docker ps --format "table {{.Names}}\t{{.Status}}"
fi

# Mongo Dump
if docker ps --format '{{.Names}}' | grep -q "$MONGO_CONTAINER_NAME"; then
    echo "🍃 Dumping MongoDB..."
    # Mongo typically uses MONGO_INITDB_ROOT_USERNAME, ensure your container has auth or adjust flags
    docker exec $MONGO_CONTAINER_NAME sh -c 'mongodump --username "${MONGO_INITDB_ROOT_USERNAME}" --password "${MONGO_INITDB_ROOT_PASSWORD}" --authenticationDatabase admin --archive --gzip' > "${DATE}-mongo-db.dump"

    if [ ! -s "${DATE}-mongo-db.dump" ]; then echo "❌ Mongo dump failed or is empty"; exit 1; fi
else
    echo "❌ ERROR: Container '$MONGO_CONTAINER_NAME' is not running!"
    docker ps --format "table {{.Names}}\t{{.Status}}"
fi

echo "✅ Backup process completed successfully."
