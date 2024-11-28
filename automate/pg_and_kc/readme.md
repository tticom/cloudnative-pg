
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
kubectl cnpg install generate -n cnpg-system --version 1.24.1 --replicas 3 --watch-namespace "default" > operator.yaml
kubectl create -f .\operator.yaml

kubectl apply -f .\postgres-cluster.yaml

kubectl get service -n cnpg-system cnpg-webhook-service
kubectl describe service -n cnpg-system cnpg-webhook-service

kubectl port-forward svc/cnpg-webhook-service -n cnpg-system 9443:443

kubectl get pods -n cnpg-system

kubectl logs -n cnpg-system cnpg-controller-manager-7868d6f88b-8t42h -c manager


kubectl get crd poolers.postgresql.cnpg.io
Error from server (NotFound): customresourcedefinitions.apiextensions.k8s.io "poolers.postgresql.cnpg.io" not found
<!-- 
The CustomResourceDefinition "poolers.postgresql.cnpg.io" is invalid: metadata.annotations: Too long: must have at most 262144 bytes
This error message indicates that while the cnpg-1.24.1.yaml file might have attempted to create or update the poolers.postgresql.cnpg.io CRD at some point in its history (perhaps a previous version), the current version of the file does not contain the definition. The error you're seeing during the apply command is likely related to a different CRD or resource within the applied YAML file, and it's specifically complaining about overly long annotations in the metadata. Since the poolers CRD isn't in the file, it's neither created nor updated, and therefore remains absent from the cluster. That's why kubectl get crd poolers.postgresql.cnpg.io continues to return "Not Found".

In summary, the poolers.postgresql.cnpg.io CRD is not defined in the provided YAML, explaining why the delete and get commands produce the results observed. The error message during apply is a separate issue related to another resource within the YAML. -->




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
