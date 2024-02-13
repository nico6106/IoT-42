#!/bin/bash

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-iface eth1" sh -

while ! kubectl get nodes; do echo 'Waiting for K3s to start...'; sleep 3; done

kubectl create deployment app1 --image=paulbouwer/hello-kubernetes:1.10 -e="NAME=I am app1"
kubectl create deployment app2 --image=paulbouwer/hello-kubernetes:1.10 -e="NAME=I am app2"
kubectl create deployment app3 --image=paulbouwer/hello-kubernetes:1.10 -e="NAME=I am app3"

# Expose the deployments -- assuming they all serve on port 8080
kubectl expose deployment app1 --type=ClusterIP --name=app1 --port=80
kubectl expose deployment app2 --type=ClusterIP --name=app2 --port=80
kubectl expose deployment app3 --type=ClusterIP --name=app3 --port=80

# Scale deployment app2 to have 3 replicas
kubectl scale deployment/app2 --replicas=3
kubectl apply -n kube-system -f /vagrant/ingress.yaml
