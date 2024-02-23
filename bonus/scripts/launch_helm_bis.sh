#!/bin/bash

# Download the YAML file to ensure it's available before running helm upgrade
curl -o values-minikube-minimum.yaml https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml

sudo helm upgrade --install gitlab gitlab/gitlab \
    -n gitlab \
    -f values-minikube-minimum.yaml \
    --set global.hosts.domain=my-host.internal \
    --set global.hosts.externalIP=0.0.0.0 \
    --set global.hosts.https=false \
    --timeout 600s


# sudo helm upgrade --install gitlab gitlab/gitlab \
#     -n gitlab \
#     -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
#     --set global.hosts.domain=my-host.internal \
#     --set global.hosts.externalIP=0.0.0.0 \
#     --set global.hosts.https=false \
#     --timeout 600s

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