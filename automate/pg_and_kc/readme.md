
## Prerequisites

minikube - https://minikube.sigs.k8s.io/docs/start/
kubectl - https://kubernetes.io/docs/tasks/tools/
krew - https://krew.sigs.k8s.io/
helm - https://helm.sh/docs/intro/install/
cmctl - https://cert-manager.io/docs/installation/kubectl/

On windows the easiest way is:

winget install chocolatey
choco install kubernetes-helm

Alternative Method to Install cloudnative-pg Operator

Install cnpg plugin

kubectl krew install cnpg

Verify plugin Installation 

kubectl cnpg install generate --help

Generate an operator manifest and create an instance of the operator in the cnpg-system namespace

# kubectl cnpg install generate -n cnpg-system --version 1.24.1 --replicas 1 --watch-namespace "default" > operator.yaml
kubectl cnpg install generate -n default --version 1.24.1 --replicas 3 --watch-namespace "default" > operator.yaml
kubectl create -f .\operator.yaml

[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("supersecretpass"))
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("replicationpass"))
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("keycloakpass"))
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("dicompass"))







# Order of execution

# Install the cloud native operator
.\operator\cloudnative\deploy.ps1

# Install keycloak
.\operator\keycloak\deploy.ps1

# Install Prometheus and Grafana
.\operator\Prometheus\deploy.ps1

# To access Prometheus, port-forward the Prometheus service
kubectl port-forward svc/prometheus-community-kube-prometheus 9090

# See the prometheus rules
kubectl get prometheusrules  

# Grafana is deployed with no predefined dashboards.
kubectl port-forward svc/prometheus-community-grafana 3000:80

# access Prometheus locally at http://localhost:9090
# access Grafana locally at http://localhost:3000/ providing the credentials 
# admin as username, prom-operator as password (defined in kube-stack-config.yaml).

minikube tunnel


$ curl -kivL -H 'Host: http://keycloak.192.168.49.2.nip.io:8080/' 'http://127.0.0.1:8080'
