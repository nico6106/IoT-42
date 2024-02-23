#!/bin/bash

#configure helm
echo "Configuring helm"
sudo helm repo add gitlab https://charts.gitlab.io/
sudo helm repo update
