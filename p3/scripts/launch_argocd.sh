#! /bin/sh

kubectl port-forward svc/argocd-server -n argocd 9393:443 >/dev/null &
kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
