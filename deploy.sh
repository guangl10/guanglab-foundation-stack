#!/usr/bin/env bash
# Deploy Foundation Stack to fs.guanglab.org
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
REMOTE_HOST="${GUANGLAB_SSH:-alpha-x}"
REMOTE_DIR="/home/ubuntu/projects/guanglab/foundation-stack"

echo "→ render"
cd "${ROOT}"
quarto render

echo "→ rsync _site to ${REMOTE_HOST}:${REMOTE_DIR}/"
rsync -avz --delete \
  "${ROOT}/_site/" \
  "${REMOTE_HOST}:${REMOTE_DIR}/_site/"

echo "→ remote render sanity (optional if only _site synced)"
echo "✓ https://fs.guanglab.org/"
echo ""
echo "DNS: A record fs.guanglab.org → server IP. Then on server:"
echo "  sudo certbot --nginx -d fs.guanglab.org"
echo "  sudo ln -sf .../fs.guanglab.org.conf /etc/nginx/sites-enabled/"
