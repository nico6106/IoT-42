#!/bin/bash

error_exit() {
  echo "Error: $1" >&2
  exit 1
}

echo "Creating k3d cluster..."
k3d cluster create bonus --port "8888:31728@server:0" || error_exit "Failed to create k3d cluster"

echo "Deploying ArgoCD and application..."
kubectl create namespace argocd || error_exit "Failed to create namespace 'argocd'"
kubectl create namespace dev || error_exit "Failed to create namespace 'dev'"
sudo kubectl create namespace gitlab || error_exit "Failed to create namespace 'gitlab'"

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || error_exit "Failed to apply ArgoCD manifest"

#configure helm
echo "Configuring helm"
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update
sleep 2
sudo helm upgrade --install gitlab gitlab/gitlab \
    -n gitlab \
    -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
    --set global.hosts.domain=my-host.internal \
    --set global.hosts.externalIP=0.0.0.0 \
    --set global.hosts.https=false \
    --timeout 600s

#waiting for webservice to be running
echo "Waiting for app=webservice"
sudo kubectl wait --for=condition=ready --timeout=1200s pod -l app=webservice -n gitlab

# gitlab localhost:80 or http://my-host.internal
echo "forwarding port"
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 >/dev/null 2>&1 &

#get PWD for gitlab
echo -n "GITLAB PASSWORD : "
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo ""
echo -n "cle ssh :"

#showing ssh key
cat ~/.ssh/id_rsa.pub
echo ""

echo "Setup complete. Gitlab is running on http://my-host.internal. Create iot-42 project manually then launch argocd with make argocd"