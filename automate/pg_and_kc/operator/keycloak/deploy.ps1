
minikube addons enable ingress

# Install CRDs
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# # Create an instance of keycloak
# kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/kubernetes.yml


kubectl apply -f ..\..\base\keycloak\keycloak-instance.yaml

kubectl create -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak.yaml

kubectl apply -f ..\..\base\keycloak\realm.yaml


$minikubeIp = & minikube ip
# 192.168.49.2
$keycloakUrl = "http://keycloak.$minikubeip.nip.io"

$yamlUrl = "https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak-ingress.yaml"
# (Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl | kubectl apply -f -
(Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl > keycloak-ingress.yaml

kubectl create -f ..\..base\keycloak\keycloak-ingress.yaml

Write-Host "Keycloak:               $keycloakUrl"
Write-Host "Keycloak:               $keycloakUrl/admin"
Write-Host "Keycloak:               $keycloakUrl/realms"

minikube tunnel

