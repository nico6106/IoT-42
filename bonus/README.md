# Installation Guide

This guide provides instructions for setting up the application using the provided scripts and configuration files.

## Prerequisites

- Docker installed and running
- `kubectl` command-line tool installed
- `k3d` tool installed
- `Helm` installed

If these tools are not installed, the `setupVM.sh` script will attempt to install them for you.

## Setup Process

1. **Prepare the Virtual Machine**

   Run the `setupVM.sh` script to update system packages, install Docker, `kubectl`, `k3d` and `Helm` if they are not already installed.

   ```sh
   make
    ```

2. **Add user permissions**

   Manually assign yourself to the docker group or logout/login for changes to be applied

   ```sh
   newgrp docker
    ```

3. **Create and Configure the k3d Cluster**

   Execute the launch.sh script to create a k3d cluster named bonus and deploy Gitlab.

   ```sh
   make launch
    ```
   
   Gitlab can be accessed at http://my-host.internal. Create a new project called iot-42 and mv files from the public repo https://github.com/Tonio2/IoT-nlesage into it.

4. **Access ArgoCD UI**

   Use the `launch_argocd.sh` script to apply the ArgoCD configuration from `confs/argocd.yaml`, port-forward ArgoCD's server to localhost and retrieve the initial admin password.

   ```sh
   make argocd
    ```

   The ArgoCD UI will be accessible via http://localhost:9393. Log in with the username admin and the password displayed by the script.