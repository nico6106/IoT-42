#Starts the whole app
all:
	./scripts/setupVM.sh

#Reloads the whole app
re: clean launch1

launch1:
	./scripts/launch.sh
	./scripts/launch_helm.sh

launch2:
	./scripts/launch_helm_bis.sh

helm:
	./scripts/launch_helm.sh

bis:
	./scripts/launch_helm_bis.sh

clean:
	./scripts/cleanup.sh

argocd:
	./scripts/launch_argocd.sh
