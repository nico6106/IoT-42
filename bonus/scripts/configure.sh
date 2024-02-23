#!/bin/bash

#configure k3d
echo "Configuring k3d"
sudo k3d cluster create p3 --port "8888:31728@server:0"
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab

sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#configure helm
echo "Configuring helm"
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update
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

# argocd localhost:80 or http://my-host.internal
echo "forwarding port"
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 80:8181 2>&1 >/dev/null &

#get PWD for gitlab
echo -n "GITLAB PASSWORD : "
sudo kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 --decode
echo ""
echo -n "cle ssh :"

#showing ssh
cd
cd .ssh
cat id_rsa.pub
echo ""