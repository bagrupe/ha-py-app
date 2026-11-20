#!bin/bash
# Creates a backup of the media files from payload.

PAYLOAD_CONTAINER_NAME="hameln-bereich-b"

# Function to check if a container is running
container_is_running() {
  local container_name=$1
  docker ps --filter name=$container_name --format '{{.Names}}' | grep -q "$container_name"
}


if container_is_running "$PAYLOAD_CONTAINER_NAME"; then
  echo "Bereich-B/Payload container '$PAYLOAD_CONTAINER_NAME' is running. Proceeding with media dump."
  docker cp $PAYLOAD_CONTAINER_NAME:/app/uploads/media ./bereich-b-media-dump/


else
  echo "❌ Bereich-B/Payload container container '$PAYLOAD_CONTAINER_NAME' is not running. Skipping media dump."
  exit 1;

fi

echo "✅ Media backup process completed successfully."
