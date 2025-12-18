#!/usr/bin/env bash
set -e

TENANT="$1"

if [[ -z "$TENANT" ]]; then
  echo "Usage: $0 <tenant-name>"
  exit 1
fi

: "${DO_SPACES_BUCKET:?Missing DO_SPACES_BUCKET}"
: "${DO_SPACES_REGION:?Missing DO_SPACES_REGION}"
: "${DO_SPACES_ACCESS_KEY:?Missing DO_SPACES_ACCESS_KEY}"
: "${DO_SPACES_SECRET_KEY:?Missing DO_SPACES_SECRET_KEY}"

OUT_DIR="/etc/thanos"
OUT_FILE="${OUT_DIR}/${TENANT}-objstore.yml"

mkdir -p "$OUT_DIR"

cat <<EOF > "$OUT_FILE"
type: S3
prefix: ${TENANT}
config:
  bucket: ${DO_SPACES_BUCKET}
  endpoint: ${DO_SPACES_REGION}.digitaloceanspaces.com
  access_key: ${DO_SPACES_ACCESS_KEY}
  secret_key: ${DO_SPACES_SECRET_KEY}
  insecure: false
  signature_version2: false
EOF

chmod 600 "$OUT_FILE"

echo "✅ Thanos object store config created: $OUT_FILE"
