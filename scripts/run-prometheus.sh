#!/usr/bin/env bash

TENANT=$1
PORT=$2

if [ -z "$TENANT" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <tenant-name> <port>"
  exit 1
fi

BASE_DIR=$(cd "$(dirname "$0")/.." && pwd)

echo "Starting Prometheus for tenant: $TENANT on port $PORT"

prometheus \
  --config.file=$BASE_DIR/tenants/$TENANT/prometheus.yml \
  --storage.tsdb.path=$BASE_DIR/data/$TENANT \
  --web.listen-address=:$PORT
