# Part 3 (k3d + Argo CD)

Goal: create a k3d Kubernetes cluster, install Argo CD in its own namespace, and deploy an app into the `dev` namespace from a GitHub repo.

## 1) Prerequisites (host)
- Docker
- kubectl
- k3d
- (optional) argocd CLI

## 2) Create cluster + install Argo CD
From the `p3` folder, run:

./scripts/bootstrap.sh

This will:
- Create a k3d cluster using [k3d-cluster.yaml](k3d-cluster.yaml)
- Create namespace `argocd`
- Install Argo CD
- Create namespace `dev`

## 3) Create your GitHub repo with manifests
Push the content of the `manifests/` folder to a GitHub repo. Example:

repo: https://github.com/<you>/iot-p3
path: manifests

## 4) Configure Argo CD Application
Edit [argocd/application.yaml](argocd/application.yaml):
- Replace REPO_URL with your GitHub repo URL
- Ensure `path: manifests` matches the repo path

Then apply it:

./scripts/create-app.sh

## 5) Verify
- kubectl get ns
- kubectl -n argocd get pods
- kubectl -n dev get pods

## 6) Access Argo CD UI (optional)
Port-forward:

kubectl -n argocd port-forward svc/argocd-server 8080:443

Then open https://localhost:8080 (accept self-signed cert).

Initial admin password:

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
