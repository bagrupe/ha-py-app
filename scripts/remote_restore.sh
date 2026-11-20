#!/usr/bin/env bash
# Restores the postgres and mongodb database based on a database dump file.
# Keep in mind the existing database data is lost and overwritten with the database dump data.

# Exit immediately if a command exits with a non-zero status
set -e

echo "🔍 Starting remote database restore process..."

# 1. Find containers dynamically
POSTGRES_CONTAINER=$(docker ps --format '{{.Names}}' | grep 'postgres' | head -n 1)
MONGO_CONTAINER=$(docker ps --format '{{.Names}}' | grep 'mongodb' | head -n 1)

if [ -z "$POSTGRES_CONTAINER" ]; then
    echo "❌ ERROR: Could not find a running Postgres container."
    exit 1
fi

if [ -z "$MONGO_CONTAINER" ]; then
    echo "❌ ERROR: Could not find a running MongoDB container."
    exit 1
fi

echo "✅ Found containers: $POSTGRES_CONTAINER, $MONGO_CONTAINER"

# 2. Ensure Environment Variables are set
# If variables are not in the shell environment, we attempt to discover them from the running containers.

# Postgres Discovery
if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ]; then
    echo "🔍 Postgres variables missing in shell, discovering from $POSTGRES_CONTAINER..."
    POSTGRES_USER=${POSTGRES_USER:-$(docker exec "$POSTGRES_CONTAINER" env | grep '^POSTGRES_USER=' | cut -d'=' -f2- | tr -d '\r')}
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-$(docker exec "$POSTGRES_CONTAINER" env | grep '^POSTGRES_PASSWORD=' | cut -d'=' -f2- | tr -d '\r')}
    POSTGRES_DB=${POSTGRES_DB:-$(docker exec "$POSTGRES_CONTAINER" env | grep '^POSTGRES_DB=' | cut -d'=' -f2- | tr -d '\r')}
fi

# MongoDB Discovery
if [ -z "$MONGO_INITDB_ROOT_USERNAME" ] || [ -z "$MONGO_INITDB_ROOT_PASSWORD" ]; then
    echo "🔍 MongoDB variables missing in shell, discovering from $MONGO_CONTAINER..."
    MONGO_INITDB_ROOT_USERNAME=${MONGO_INITDB_ROOT_USERNAME:-$(docker exec "$MONGO_CONTAINER" env | grep '^MONGO_INITDB_ROOT_USERNAME=' | cut -d'=' -f2- | tr -d '\r')}
    MONGO_INITDB_ROOT_PASSWORD=${MONGO_INITDB_ROOT_PASSWORD:-$(docker exec "$MONGO_CONTAINER" env | grep '^MONGO_INITDB_ROOT_PASSWORD=' | cut -d'=' -f2- | tr -d '\r')}
fi

# 3. Postgres Restore
# Check both local and migration directory paths
PG_FILE=$(ls ./database_dumps/*-postgres.dump /home/deploy_user/migration/database_dumps/*-postgres.dump 2>/dev/null | head -n 1)
if [ -n "$PG_FILE" ] && [ -f "$PG_FILE" ]; then
    echo "🔨 Restoring Postgres from $PG_FILE..."
    docker cp "$PG_FILE" "$POSTGRES_CONTAINER:/tmp/restore.dump"
    # Validate Postgres variables
    if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ]; then
        echo "❌ ERROR: Postgres restoration failed due to missing credentials (USER, PASSWORD, or DB)."
        exit 1
    fi

    docker exec "$POSTGRES_CONTAINER" sh -c "
        export PGPASSWORD='$POSTGRES_PASSWORD'
        psql -U '$POSTGRES_USER' -d '$POSTGRES_DB' -c 'DROP SCHEMA public CASCADE; CREATE SCHEMA public;'
        pg_restore -U '$POSTGRES_USER' -d '$POSTGRES_DB' --no-owner --no-privileges /tmp/restore.dump
    "
    echo "✅ Postgres restore completed."
else
    echo "⚠️ No Postgres dump found matching *-postgres.dump"
fi

# 3. Mongo Restore
# Check both local and migration directory paths
MONGO_FILE=$(ls ./database_dumps/*-mongo-db.dump /home/deploy_user/migration/database_dumps/*-mongo-db.dump 2>/dev/null | head -n 1)
if [ -n "$MONGO_FILE" ] && [ -f "$MONGO_FILE" ]; then
    echo "🔨 Restoring MongoDB from $MONGO_FILE..."
    docker cp "$MONGO_FILE" "$MONGO_CONTAINER:/tmp/restore.dump"
    # Validate MongoDB variables
    if [ -z "$MONGO_INITDB_ROOT_USERNAME" ] || [ -z "$MONGO_INITDB_ROOT_PASSWORD" ]; then
        echo "❌ ERROR: MongoDB restoration failed due to missing credentials (USERNAME or PASSWORD)."
        exit 1
    fi

    # Restore the mongodb based on the dump file.
    docker exec -e MONGO_USER="$MONGO_INITDB_ROOT_USERNAME" -e MONGO_PASS="$MONGO_INITDB_ROOT_PASSWORD" "$MONGO_CONTAINER" sh -c 'mongorestore --username "$MONGO_USER" \
                     --password "$MONGO_PASS" \
                     --authenticationDatabase admin \
                     --drop \
                     --archive=/tmp/restore.dump \
                     --gzip \
                     --nsExclude="admin.*" \
                     --nsExclude="config.*"'


    echo "✅ MongoDB restore completed."
else
    echo "⚠️ No MongoDB dump found matching *-mongo-db.dump"
fi

echo "✅ Remote restore process finished."
