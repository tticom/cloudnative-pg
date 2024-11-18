$Error.Clear()

# Enable Minikube ingress addon
minikube addons enable ingress

# Get Minikube IP and construct Keycloak URL
$minikubeIp = & minikube ip
$keycloakUrl = "keycloak.$minikubeip.nip.io"
$yamlUrl = "https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak-ingress.yaml"

try {

# Install CRDs
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
} catch {
  Write-Error "Failed to install keycloak CRDs: $_"
}

# Create an instance of keycloak
try {

  # Returns 404
  # kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/kubernetes.yml

  kubectl apply -f ..\..\base\keycloak\keycloak-instance.yaml
  kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak.yaml
  kubectl apply -f ..\..\base\keycloak\realm.yaml

  (Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl | kubectl apply -f -
} catch {
  Write-Error "An error occurred: $_\n"
  exit 1
}

# (Invoke-WebRequest -Uri $yamlUrl -UseBasicParsing).Content -replace "KEYCLOAK_HOST", $keycloakUrl > ..\..base\keycloak\offline\keycloak-ingress.yaml

# kubectl create -f ..\..base\keycloak\offline\keycloak-ingress.yaml

Write-Host "Keycloak:               $keycloakUrl"
Write-Host "Keycloak:               $keycloakUrl/admin"
Write-Host "Keycloak:               $keycloakUrl/realms"

if ($Error.count -gt 0){
  Write-Host "One or more error occurred during execution. Try running the script again and checking the logs."
  exit 1
} else {
  Write-Host "Keycloak deployment successful, check the running pods"
  Write-Host "Starting minikube tunnel..."
  minikube tunnel
}

