#!/bin/bash

error_exit() {
  echo "Error: $1" >&2
  exit 1
}
pwd
if [ -f "./confs/deploy.yaml" ]; then
  sudo kubectl apply -f ./confs/deploy.yaml || error_exit "Failed to apply './confs/deploy.yaml'"
else
  echo "Warning: 'confs/deploy.yaml' not found. Skipping application deployment."
  exit
fi

sudo kubectl port-forward svc/argocd-server -n argocd 9393:443 >/dev/null &
sudo kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
