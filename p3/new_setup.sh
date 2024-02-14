#!/bin/sh

# Function to check if a command exists
command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# Function to handle errors
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

echo "Updating system packages..."
sudo apt update || error_exit "Failed to update packages"
sudo apt upgrade -y || error_exit "Failed to upgrade packages"

echo "Installing prerequisites..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common || error_exit "Failed to install prerequisites"

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

echo "Installing kubectl..."
KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" || error_exit "Failed to download kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo "Installing k3d..."
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash || error_exit "Failed to install k3d"

echo "Creating k3d cluster..."
k3d cluster create mycluster --port "8888:31728@server[0]" || error_exit "Failed to create k3d cluster"

echo "Deploying ArgoCD and application..."
kubectl create namespace argocd || error_exit "Failed to create namespace 'argocd'"
kubectl create namespace dev || error_exit "Failed to create namespace 'dev'"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml || error_exit "Failed to apply ArgoCD manifest"

if [ -f "confs/argocd.yaml" ]; then
  kubectl apply -f confs/argocd.yaml || error_exit "Failed to apply 'confs/argocd.yaml'"
else
  echo "Warning: 'confs/argocd.yaml' not found. Skipping application deployment."
fi

echo "Setup complete. Verify the deployment status with 'kubectl get pods -n argocd' and 'kubectl get pods -n dev'"

