#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

kubectl apply -f "$ROOT_DIR/manifests/apps.yaml"

kubectl -n iot-p2 get pods -o wide
kubectl -n iot-p2 get svc
kubectl -n iot-p2 get ingress
