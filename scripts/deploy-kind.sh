#!/usr/bin/env bash
set -euo pipefail
IMAGE="${1:-}"
if [ -z "$IMAGE" ]; then
  echo "Usage: ./scripts/deploy-kind.sh <container-image>"
  exit 1
fi
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl -n cicd-lab set image deployment/cloud-admin-web web="$IMAGE"
kubectl -n cicd-lab rollout status deployment/cloud-admin-web --timeout=180s
kubectl -n cicd-lab get pods -o wide
kubectl -n cicd-lab get service cloud-admin-web-service
