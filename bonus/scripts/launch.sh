#!/bin/bash

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

echo "Creating k3d cluster..."
sudo k3d cluster create bonus --port "8888:31728@server:0" || error_exit "Failed to create k3d cluster"

echo "Deploying ArgoCD and application..."
sudo kubectl create namespace argocd || error_exit "Failed to create namespace 'argocd'"
sudo kubectl create namespace dev || error_exit "Failed to create namespace 'dev'"
sudo kubectl create namespace gitlab || error_exit "Failed to create namespace 'gitlab'"

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || error_exit "Failed to apply ArgoCD manifest"
