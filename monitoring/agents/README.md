# Monitoring Agents

Exporter stack deployed on each app VM (Staging, PreProd, Production). Prometheus on the monitoring VM scrapes these agents.

| Agent | Port | Source | Metrics |
|-------|------|--------|---------|
| Node Exporter | 9100 | **Host** (pre-installed on VM) | Host CPU, memory, disk, network |
| cAdvisor | 8081 | Docker (this stack) | Docker container resource usage |
| Postgres Exporter | 9187 | Docker (this stack) | PostgreSQL database metrics |
| MongoDB Exporter | 9216 | Docker (this stack) | MongoDB database metrics |

Runs as a separate compose project (`hameln-monitoring-agents`) so app deployments do not affect the agents.

**Node Exporter** is not part of this compose stack — each app VM already runs a host-level `node_exporter`. Prometheus scrapes it directly on port `9100` (default). No config changes needed on your side unless the port differs.

## Prerequisites

### 1. Host Node Exporter

Verify the pre-installed exporter on each app VM (SSH):

```bash
curl -s http://127.0.0.1:9100/metrics | head
ss -tlnp | grep 9100
```

Confirm:

- `/metrics` returns Prometheus text format (lines like `node_cpu_seconds_total`)
- It listens on `9100` (or note the actual port for Prometheus config)
- The monitoring VM can reach that port

If the host exporter uses a **non-default port**, update `monitoring/prometheus/prometheus.yml` accordingly.

### 2. App stack running

The agents join the existing `hameln-pyrmont` Docker network to reach `postgres` and `mongodb`. The app stack must be running before starting the DB exporters.

### 3. Database monitoring users

Read-only `monitoring` users are created automatically:

- **New databases:** `docker/postgres/init/02-monitoring-user.sh` and `docker/mongodb/init/02-monitoring-user.sh` run on first container start (empty data volume).
- **Existing databases:** `scripts/ensure-monitoring-db-users.sh` runs on every `monitoring-agents-deploy` (idempotent).

Set these in `DEPLOYMENT_ENV_FILE` (per environment):

```dotenv
POSTGRES_MONITORING_PASSWORD=REPLACE_ME
MONGO_MONITORING_PASSWORD=REPLACE_ME
```

Use the **same passwords** in `MONITORING_ENV_FILE` (scoped to the app environment) for the exporters:

```dotenv
POSTGRES_EXPORTER_DATA_SOURCE_NAME=postgresql://monitoring:YOUR_PG_PASSWORD@postgres:5432/domain?sslmode=disable
MONGODB_EXPORTER_URI=mongodb://monitoring:YOUR_MONGO_PASSWORD@mongodb:27017/admin?authSource=admin
```

Special characters in passwords must be URL-encoded in the exporter connection strings.

**Manual verification** (optional):

```bash
docker exec hameln-postgres psql -U monitoring -d domain -c 'SELECT 1;'
docker exec hameln-mongodb mongosh -u monitoring -p 'YOUR_MONGO_PASSWORD' \
  --authenticationDatabase admin --eval 'db.runCommand({ connectionStatus: 1 })'
```

**One-time on existing VMs** (if not deploying via CI yet):

```bash
cd /home/deploy_user/monitoring-agents
set -a && source ./.env && set +a
bash ./ensure-monitoring-db-users.sh
```

### 4. GitLab CI variable

Add exporter settings to the **File** variable `MONITORING_ENV_FILE` scoped to each app GitLab environment (`staging`, `preprod`, `production`). Use the monitoring passwords from `DEPLOYMENT_ENV_FILE`:

```dotenv
POSTGRES_EXPORTER_DATA_SOURCE_NAME=postgresql://monitoring:YOUR_PG_PASSWORD@postgres:5432/domain?sslmode=disable
MONGODB_EXPORTER_URI=mongodb://monitoring:YOUR_MONGO_PASSWORD@mongodb:27017/admin?authSource=admin
```

## Deployment

Deployed via GitLab CI jobs (manual trigger on `main` when `monitoring/agents/**/*` changes):

- `monitoring-agents:deploy:staging`
- `monitoring-agents:deploy:preprod`
- `monitoring-agents:deploy:production`

After deploying agents, redeploy the monitoring stack (`monitoring:deploy`) so Prometheus picks up scrape targets.

### Manual deploy (without CI)

```bash
# On the target app VM
mkdir -p /home/deploy_user/monitoring-agents
# Copy monitoring/agents/* and .env to the VM, then:
cd /home/deploy_user/monitoring-agents
docker compose -f docker-compose.yml -p hameln-monitoring-agents --env-file .env pull
docker compose -f docker-compose.yml -p hameln-monitoring-agents --env-file .env up -d
```

## Verification

On the app VM:

```bash
docker compose -p hameln-monitoring-agents ps
curl -s http://localhost:9100/metrics | head   # host node_exporter
curl -s http://localhost:8081/metrics | head
curl -s http://localhost:9187/metrics | head
curl -s http://localhost:9216/metrics | head
```

From the monitoring VM:

```bash
curl -s http://<APP_VM_IP>:9100/metrics | head
```

In Grafana → Explore → Prometheus, query e.g. `up{job="node-exporter"}`.

## Stop

```bash
cd /home/deploy_user/monitoring-agents
docker compose -f docker-compose.yml -p hameln-monitoring-agents down --remove-orphans
```

Or use the corresponding `monitoring-agents:stop:*` CI job.
