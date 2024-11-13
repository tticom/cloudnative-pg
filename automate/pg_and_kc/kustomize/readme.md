
## Prerequisites

minikube - https://minikube.sigs.k8s.io/docs/start/
kubectl - https://kubernetes.io/docs/tasks/tools/
kuztomize - https://kustomize.io/
helm - https://helm.sh/docs/intro/install/

On windows the easiest way is:

winget install chocolatey
choco install kustomize
choco install kubernetes-helm


# Useful for bash

chmod +x deploy.sh
chmod +x deploy-dicom.sh
chmod +x deploy-keycloak.sh

# Order of execution
chmod +x deploy.sh/.ps1
chmod +x deploy-dicom.sh/.ps1
chmod +x deploy-keycloak.sh/.ps1
