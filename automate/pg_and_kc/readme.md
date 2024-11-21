
## Prerequisites

minikube - https://minikube.sigs.k8s.io/docs/start/
kubectl - https://kubernetes.io/docs/tasks/tools/
helm - https://helm.sh/docs/intro/install/
cmctl - https://cert-manager.io/docs/installation/kubectl/

On windows the easiest way is:

winget install chocolatey
choco install kubernetes-helm

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
