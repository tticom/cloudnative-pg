
$minikubeIp = & minikube ip
# 192.168.49.2
$keycloakUrl = "http://keycloak.$minikubeip.nip.io"

$yamlUrl = "https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak-ingress.yaml"
# (Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl | kubectl apply -f -
(Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl > keycloak-ingress.yaml

kubectl create -f .\keycloak-ingress.yaml


Write-Host "Keycloak:               $keycloakUrl"
Write-Host "Keycloak:               $keycloakUrl/admin"
Write-Host "Keycloak:               $keycloakUrl/realms"


