#!/bin/bash

sudo kubectl apply -f ./confs/deploy.yaml

sudo kubectl port-forward svc/argocd-server -n argocd 9393:443 >/dev/null &
sudo kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
