#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v k3d >/dev/null 2>&1; then
  echo "k3d not found. Install k3d first." >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found. Install kubectl first." >&2
  exit 1
fi

echo "Creating k3d cluster..."
k3d cluster create --config "$ROOT_DIR/k3d-cluster.yaml"

echo "Creating argocd namespace..."
kubectl apply -f "$ROOT_DIR/argocd/namespace.yaml"

echo "Installing Argo CD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD server..."
kubectl -n argocd wait deployment/argocd-server --for=condition=Available --timeout=300s

echo "Creating dev namespace..."
kubectl apply -f "$ROOT_DIR/manifests/namespace-dev.yaml"

echo "Done. Edit argocd/application.yaml and run scripts/create-app.sh"
