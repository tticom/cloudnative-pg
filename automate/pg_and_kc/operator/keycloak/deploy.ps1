$Error.Clear()

# Enable Minikube ingress addon
# minikube addons enable ingress

# not required if using minikube 
# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-2---deploy-the-nginx-ingress-controller
# Add the latest helm repository for the ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install quickstart ingress-nginx/ingress-nginx

# https://cert-manager.io/docs/installation/helm/
# Add the Helm repository
helm repo add jetstack https://charts.jetstack.io --force-update
# Install cert-manager
helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.16.1 --set crds.enabled=true

# # https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-2---deploy-the-nginx-ingress-controller
# # install the issuers
# # Only for testting because the prod issuer has severe usuage restrictions on prod
kubectl apply -f ..\..\base\keycloak\staging-issuer.yaml
kubectl apply -f ..\..\base\keycloak\prod-issuer.yaml

# kubectl get svc
  
# Write-Host "Waiting for 60 seconds to ensure ingress-nginx is installed..."
# Start-Sleep -Seconds 60

# Get Minikube IP and construct Keycloak URL
# $minikubeIp = & minikube ip
# $keycloakUrl = keycloak.192.168.49.2.nip.io
# keycloak.192.168.49.2.nip.io needs to be mapped to 127.0.0.1 in the c:\windows\system32\drivers\etc\hosts file
# $keycloakUrl = "keycloak.$minikubeip.nip.io"
# $keycloakUrl = "local.keycloak.nip.io"
# $keycloakUrl = "local.keycloak.io"
$instanceYaml = "..\..\base\keycloak\keycloak-instance.yaml"
# $ingressYaml = "..\..\base\keycloak\keycloak-ingress.yaml"

# Install the keycloak operator
# https://www.keycloak.org/operator/installation
try {  
  # Install CRDs
  kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
  kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

  # Install the Keycloak Operator deployment
  kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/kubernetes.yml
} catch {
  Write-Error "Failed to install keycloak CRDs: $_"
}

# Create Secrets
# https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-2---deploy-the-nginx-ingress-controller
kubectl apply -f ..\..\base\keycloak\test\keycloak-ingress-test.yaml

# # Create an instance of keycloak
try {

  $dbUsername = & kubectl get secret keycloak-postgres-db-cluster-app -o jsonpath="{.data.username}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
  $dbPassword = & kubectl get secret keycloak-postgres-db-cluster-app -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

  # deployment and loadbalancer
  kubectl apply -f ..\..\base\keycloak\deployment\keycloak.yaml

  (Get-Content -Path $instanceYaml) -replace "DB_USERNAME", $dbUsername -replace "DB_PASSWORD", $dbPassword | kubectl apply -f -
  
  Write-Host "Waiting for 60 seconds to ensure keycloak instance is ready..."
  Start-Sleep -Seconds 60

  # display statuses of the instance
  # kubectl get keycloaks/keycloak-instance -o go-template='{{range .status.conditions}}CONDITION: {{.type}}{{"\n"}}  STATUS: {{.status}}{{"\n"}}  MESSAGE: {{.message}}{{"\n"}}{{end}}'

#   kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/kubernetes/keycloak.yaml

#   # Attempt to import realm file, doesn't seem to work
#   kubectl apply -f ..\..\base\keycloak\realm.yaml

#   (Get-Content -Path $ingressYaml) -replace "KEYCLOAK_HOST", $keycloakUrl | kubectl apply -f -

#   # Install cert-manager
#   # kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.yaml
  
#   # Write-Host "Waiting for 60 seconds to ensure cert-manager is installed..."
#   # Start-Sleep -Seconds 60



} catch {
  Write-Error "An error occurred: $_\n"
  exit 1
}

# Write-Host "Keycloak:               $keycloakUrl"
# Write-Host "Keycloak:               $keycloakUrl/admin"
# Write-Host "Keycloak:               $keycloakUrl/realms/Blackford-Platform/account"

# if ($Error.count -gt 0){
#   Write-Host "One or more error occurred during execution. Try running the script again and checking the logs."
#   exit 1
# }

# shouldn't need to port-forward with ingress enabled and nginx-ingress configured
# kubectl port-forward service/keycloak-instance-service 80:8443
# kubectl port-forward service/keycloak-instance-service 443:8443