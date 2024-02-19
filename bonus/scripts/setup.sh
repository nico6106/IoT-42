curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm repo add gitlab https://charts.gitlab.io
helm repo update

kubectl create namespace gitlab

helm install gitlab gitlab/gitlab \
  --namespace gitlab \
  --set global.hosts.domain=localdomain.com \
  --set global.hosts.externalIP=<your-cluster-ip> \
  --set certmanager-issuer.email=<your-email>


helm install gitlab gitlab/gitlab --namespace gitlab --set global.hosts.domain=localdomain.com --set global.hosts.externalIP=<your-cluster-ip> --set certmanager-issuer.email=<your-email> 

