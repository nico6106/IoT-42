#!/bin/bash

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server --node-ip 192.168.56.110" sh - 

while ! kubectl get nodes; do echo 'Waiting for K3s to start...'; sleep 3; done

kubectl apply -f /vagrant/app1.yaml
kubectl apply -f /vagrant/app2.yaml
kubectl apply -f /vagrant/app3.yaml

kubectl scale deployment app-two --replicas=3

kubectl apply -f /vagrant/ingress.yaml
