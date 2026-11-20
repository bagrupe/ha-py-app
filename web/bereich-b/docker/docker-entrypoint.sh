#!/bin/sh
set -eu

# Named volumes mount over image layers; the volume root is often root-owned (755).
# Give the app user ownership so Payload can mkdir/write subdirs on first upload.
chown -R nextjs:nodejs /app/bereich-b/uploads

exec su-exec nextjs "$@"
