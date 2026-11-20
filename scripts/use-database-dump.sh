#!bin/bash
# Imports datbase dump files for local postgres and mongodb databases.

# ENVIRONMENT VARIABLES
POSTGRES_USER=admin
POSTGRES_PASSWORD=password
PGDATABASE=db
POSTGRES_CONTAINER_NAME=hapy-postgres

MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=password
MONGO_CONTAINER_NAME=hapy-mongodb

# CHANGE FOLDER TO SOMETHING ELSE IF NEEDED
DUMP_FOLDER_PATH="./dumps/20260211/"
BEREICH_A_DUMP="$DUMP_FOLDER_PATH/bereich-a.dump"
BEREICH_B_DUMP="$DUMP_FOLDER_PATH/bereich-b.dump"

################################################
# CHECK DUMP FOLDER
################################################

echo -e "\n#######################################################"
echo "🔍 CHECK IF DUMP FOLDER EXISTS AND CONTAINS FILES"
echo -e "#######################################################\n"


shopt -s nullglob

files=("$DUMP_FOLDER_PATH"/*)

if [ ${#files[@]} -gt 0 ]; then
    echo "✅ $DUMP_FOLDER_PATH CONTAINS FILES"
else
    echo "❌ $DUMP_FOLDER_PATH CONTAINS NO FILES OR DOES NOT EXISTS"
    echo "DOWNLOAD A DUMP FOLDER FROM THE NEXTCLOUD SPACE"
    exit 0;
fi


if [ -f $BEREICH_A_DUMP ];then
    echo "✅ BEREICH-A DUMP EXISTS"
else
    echo "❌ BEREICH-A DUMP DOES NOT EXISTS"
    echo "PLEASE CHECK IF A FILE ON PATH $BEREICH_A_DUMP EXISTS"
    exit 0;
fi


if [ -f $BEREICH_B_DUMP ];then
    echo "✅ BEREICH-B DUMP EXISTS"
else
    echo "❌ BEREICH-B DUMP DOES NOT EXISTS"
    echo "PLEASE CHECK IF A FILE ON PATH $BEREICH_B_DUMP EXISTS"
    exit 0;
fi



################################################
# CHECK IF DOCKER CONTAINERS ARE AVAILABLE
################################################

echo -e "\n#######################################################"
echo "🔍 CHECK IF POSTGRES AND MONGODB CONTAINERS ARE RUNNING"
echo -e "#######################################################\n"

MONGO_DB_CONTAINER_ID=$(docker ps --filter name=$MONGO_CONTAINER_NAME -q)
POSTGRES_DB_CONTAINER_ID=$(docker ps --filter name=$POSTGRES_CONTAINER_NAME -q)

if [ -z $MONGO_DB_CONTAINER_ID ];then
    echo -e "❌ MONGODB CONTAINER IS NOT RUNNING OR IS NAMED DIFFERNTLY.\n PLEASE CHECK IF THE CONTAINER IS RUNNING AND NAMED $MONGO_CONTAINER_NAME"
    exit 0;
else
    echo "✅ MONGODB CONTAINER IS RUNNING"
fi

if [ -z $POSTGRES_DB_CONTAINER_ID ];then
    echo -e "❌ POSTGRES CONTAINER IS NOT RUNNING OR IS NAMED DIFFERNTLY.\n PLEASE CHECK IF THE CONTAINER IS RUNNING AND NAMED $POSTGRES_CONTAINER_NAME"
    exit 0;
else
    echo "✅ POSTGRES CONTAINER IS RUNNING"
fi



################################################
# IMPORT POSTGRES DATA DUMP
################################################

echo -e "\n#######################################################"
echo "🔨 IMPORT POSTGRES DATA DUMP"
echo -e "#######################################################\n"


DELETE OLD DATABASE
docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" -e PGUSER="$POSTGRES_USER" $POSTGRES_CONTAINER_NAME psql --dbname=$PGDATABASE -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public to $POSTGRES_USER;"

docker cp $BEREICH_A_DUMP $POSTGRES_CONTAINER_NAME:/ | echo "✅ SUCCESSFULLY COPIED BEREICH_A DATA DUMP $POST POSTGRES_CONTAINER_NAME CONTAINER"

# IMPORT DATABASE DUMP
docker exec -e PGPASSWORD=$POSTGRES_PASSWORD -e PGUSER=$POSTGRES_USER $POSTGRES_CONTAINER_NAME pg_restore --format=c --no-owner --no-privileges --dbname=$PGDATABASE --clean --if-exists /bereich-a.dump

echo "✅ SUCCESSFULLY IMPORTED THE DATABASE DUMP TO THE POSTGRES CONTAINER"


################################################
# IMPORT MONGODB DATA DUMP
################################################

echo -e "\n#######################################################"
echo "🔨 IMPORT MONGODB DATA DUMP"
echo -e "#######################################################\n"

docker cp $BEREICH_B_DUMP $MONGO_CONTAINER_NAME:/ | echo "✅ SUCCESSFULLY COPIED BEREICH_B DATA DUMP $MONGO_CONTAINER_NAME CONTAINER"

docker exec $MONGO_CONTAINER_NAME mongorestore --username $MONGO_INITDB_ROOT_USERNAME --password $MONGO_INITDB_ROOT_PASSWORD --authenticationDatabase admin --nsInclude "bereich-b.*" --drop --archive=/bereich-b.dump --gzip

echo "✅ SUCCESSFULLY IMPORTED THE DATABASE DUMP TO THE MONGODB CONTAINER"


echo -e "\n#######################################################"
echo "✅ SUCCESSFULLY UPDATED THE DATABASES"
echo -e "#######################################################\n"

exit 0;
