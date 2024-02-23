#!/bin/sh

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

echo "Creating k3d cluster..."
k3d cluster create p3 --port "8888:31728@server:0" || error_exit "Failed to create k3d cluster"

echo "Deploying ArgoCD and application..."
kubectl create namespace argocd || error_exit "Failed to create namespace 'argocd'"
kubectl create namespace dev || error_exit "Failed to create namespace 'dev'"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || error_exit "Failed to apply ArgoCD manifest"

if [ -f "confs/argocd.yaml" ]; then
  kubectl apply -f ./confs/argocd.yaml || error_exit "Failed to apply 'confs/argocd.yaml'"
else
  echo "Warning: 'confs/argocd.yaml' not found. Skipping application deployment."
fi

echo "Setup complete. Verify the deployment status with 'kubectl get pods -n argocd' and 'kubectl get pods -n dev'"