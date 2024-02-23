#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

#install gitlab
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt install -y apt-transport-https software-properties-common

# curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
# sudo EXTERNAL_URL="http://my-host.internal" apt-get install gitlab-ee

HOST_ENTRY="127.0.0.1   my-host.internal"
HOST_SEARCH="my-host.internal"
HOST_FILE="/etc/hosts"

if grep -q "$HOST_SEARCH" "$HOST_FILE"; then
    echo "host exists"
else
    echo "$HOST_ENTRY" | sudo tee -a "$HOST_FILE"
    echo "host added"
fi

# echo "MDP = "
# sudo cat /etc/gitlab/initial_root_password

#install helm
if command_exists helm; then
  echo "helm already installed. Skipping helm installation."
else
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
fi


#install docker
if command_exists docker; then
  echo "Docker already installed. Skipping Docker installation."
else
  echo "Installing Docker..."
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io || error_exit "Failed to install Docker"
  sudo usermod -aG docker ${USER}
  echo "Please log out and log back in to apply Docker group changes, or run 'newgrp docker'."
fi

#install kubectl
if command_exists kubectl; then
  echo "kubectl already installed. Skipping kubectl installation."
else
    echo "Installing kubectl..."
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" || error_exit "Failed to download kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    echo "Kubectl installed"
fi

#install k3d
if command_exists k3d; then
  echo "k3d already installed. Skipping k3d installation."
else
    echo "Installing k3d"
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
    echo "k3d Installed"
fi
