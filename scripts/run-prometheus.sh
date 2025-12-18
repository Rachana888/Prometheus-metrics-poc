#!/usr/bin/env bash
set -e

TENANT="$1"
PORT="$2"

if [[ -z "$TENANT" || -z "$PORT" ]]; then
  echo "Usage: $0 <tenant-name> <port>"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

PROM_CONFIG="${BASE_DIR}/tenants/${TENANT}/prometheus.yml"
DATA_DIR="${BASE_DIR}/data/${TENANT}"

if [[ ! -f "$PROM_CONFIG" ]]; then
  echo "❌ Prometheus config not found: $PROM_CONFIG"
  exit 1
fi

mkdir -p "$DATA_DIR"

echo "🚀 Starting Prometheus for tenant: $TENANT on port $PORT"
echo "    Config: $PROM_CONFIG"
echo "    Data:   $DATA_DIR"

prometheus \
  --config.file="$PROM_CONFIG" \
  --storage.tsdb.path="$DATA_DIR" \
  --storage.tsdb.retention.time=7d \
  --storage.tsdb.min-block-duration=2h \
  --storage.tsdb.max-block-duration=2h \
  --web.listen-address=":${PORT}" \
  --web.enable-lifecycle
