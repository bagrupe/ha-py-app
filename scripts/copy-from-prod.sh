#!/usr/bin/env bash

# Script from prvious provider. Currently not in use!

HOST="${SOURCE_HOST:?Set SOURCE_HOST explicitly}"
DEPLOYMENT_DIR="${SOURCE_DEPLOYMENT_DIR:?Set SOURCE_DEPLOYMENT_DIR explicitly}"
LOCAL_UPLOADS_DIR="$(git rev-parse --show-toplevel)/web/bereich-b/uploads/media"
MONGO_DATABASE_NAME=bereich-b

if ! docker compose ps --status=running --services | grep -q '^postgres$'; then
  docker compose up -d
fi

REMOTE_PG_ENV=$(tsh ssh $HOST "cd $DEPLOYMENT_DIR && docker compose exec postgres printenv 2>/dev/null")
REMOTE_PG_USER=$(echo "$REMOTE_PG_ENV" | grep -E '^POSTGRES_USER=' | cut -d'=' -f2)
REMOTE_PG_PASSWORD=$(echo "$REMOTE_PG_ENV" | grep -E '^POSTGRES_PASSWORD=' | cut -d'=' -f2)

REMOTE_MONGO_ENV=$(tsh ssh $HOST "cd $DEPLOYMENT_DIR && docker compose exec mongodb printenv 2>/dev/null")
REMOTE_MONGO_USER=$(echo "$REMOTE_MONGO_ENV" | grep -E '^MONGO_INITDB_ROOT_USERNAME=' | cut -d'=' -f2)
REMOTE_MONGO_PASSWORD=$(echo "$REMOTE_MONGO_ENV" | grep -E '^MONGO_INITDB_ROOT_PASSWORD=' | cut -d'=' -f2)

LOCAL_PG_ENV=$(docker compose exec postgres printenv)
LOCAL_PG_USER=$(echo "$LOCAL_PG_ENV" | grep -E '^POSTGRES_USER=' | cut -d'=' -f2)
LOCAL_PG_PASSWORD=$(echo "$LOCAL_PG_ENV" | grep -E '^POSTGRES_PASSWORD=' | cut -d'=' -f2)

LOCAL_MONGO_ENV=$(docker compose exec mongodb printenv)
LOCAL_MONGO_USER=$(echo "$LOCAL_MONGO_ENV" | grep -E '^MONGO_INITDB_ROOT_USERNAME=' | cut -d'=' -f2)
LOCAL_MONGO_PASSWORD=$(echo "$LOCAL_MONGO_ENV" | grep -E '^MONGO_INITDB_ROOT_PASSWORD=' | cut -d'=' -f2)

tsh ssh $HOST "cd $DEPLOYMENT_DIR && docker compose exec -e PGPASSWORD=$REMOTE_PG_PASSWORD -e PGUSER=$REMOTE_PG_USER postgres pg_dump --format=custom domain" > bereich-a.dump.tmp

tsh ssh $HOST "cd $DEPLOYMENT_DIR && docker compose exec mongodb mongodump --username $REMOTE_MONGO_USER --password $REMOTE_MONGO_PASSWORD --db $MONGO_DATABASE_NAME --authenticationDatabase admin --archive --gzip" > bereich-b.dump.tmp

docker compose exec -e PGPASSWORD="$LOCAL_PG_PASSWORD" -e PGUSER="$LOCAL_PG_USER" postgres psql --dbname=domain -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public to domain;"

docker compose exec --no-TTY -e PGPASSWORD=$LOCAL_PG_PASSWORD -e PGUSER=$LOCAL_PG_USER postgres pg_restore --format=c --no-owner --no-privileges --dbname=domain --clean --if-exists < bereich-a.dump.tmp

docker compose exec --no-TTY mongodb mongorestore --username $LOCAL_MONGO_USER --password $LOCAL_MONGO_PASSWORD --authenticationDatabase admin --nsInclude "$MONGO_DATABASE_NAME.*" --drop --archive --gzip < bereich-b.dump.tmp

rsync --rsh="tsh ssh" -avzh --progress --delete "$HOST:$DEPLOYMENT_DIR/.volumes/payload-uploads/" $LOCAL_UPLOADS_DIR

rm bereich-a.dump.tmp
rm bereich-b.dump.tmp
