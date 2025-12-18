# Prometheus Multi-Tenant (PoC)

This setup runs one Prometheus instance per tenant.

Each tenant has:
- Separate config
- Separate TSDB
- Separate Prometheus process

## Start instances

Tenant A:
./scripts/run-prometheus.sh tenant-a 9091

Tenant B:
./scripts/run-prometheus.sh tenant-b 9092

## Flow

OTel Collector → Tenant Prometheus → Grafana Org
