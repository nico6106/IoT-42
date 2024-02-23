#!/bin/bash

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

if [ -f "confs/argocd.yaml" ]; then
  kubectl apply -f ./confs/argocd.yaml || error_exit "Failed to apply 'confs/argocd.yaml'"
else
  echo "Warning: 'confs/argocd.yaml' not found. Skipping application deployment."
fi

sudo kubectl port-forward svc/argocd-server -n argocd 9393:443 >/dev/null &
sudo kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
