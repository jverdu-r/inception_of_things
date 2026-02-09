#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_FILE="$ROOT_DIR/argocd/application.yaml"

if grep -q "REPO_URL" "$APP_FILE"; then
  echo "Update repoURL in $APP_FILE before applying." >&2
  exit 1
fi

kubectl apply -f "$APP_FILE"

echo "Application created. Check sync status with: kubectl -n argocd get applications"
