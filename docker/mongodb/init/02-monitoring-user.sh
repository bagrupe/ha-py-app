#!/bin/bash
set -euo pipefail

if [ -z "${MONGO_MONITORING_PASSWORD:-}" ]; then
  echo "MONGO_MONITORING_PASSWORD is not set, skipping monitoring user creation"
  exit 0
fi

escaped_password="${MONGO_MONITORING_PASSWORD//\'/\\\'\'}"

mongosh <<EOF
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
