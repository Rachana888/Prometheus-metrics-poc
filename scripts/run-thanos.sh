#!/usr/bin/env bash
set -e

TENANT="$1"
PROM_PORT="$2"

if [[ -z "$TENANT" || -z "$PROM_PORT" ]]; then
  echo "Usage: $0 <tenant-name> <prometheus-port>"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

DATA_DIR="${BASE_DIR}/data/${TENANT}"
OBJSTORE_CONFIG="/etc/thanos/${TENANT}-objstore.yml"

if [[ ! -d "$DATA_DIR" ]]; then
  echo "❌ TSDB path not found: $DATA_DIR"
  exit 1
fi

if [[ ! -f "$OBJSTORE_CONFIG" ]]; then
  echo "❌ Object store config not found: $OBJSTORE_CONFIG"
  exit 1
fi

echo "🚀 Starting Thanos sidecar for tenant: $TENANT"

thanos sidecar \
  --tsdb.path="$DATA_DIR" \
  --prometheus.url="http://localhost:${PROM_PORT}" \
  --objstore.config-file="$OBJSTORE_CONFIG"

