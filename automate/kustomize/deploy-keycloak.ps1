# Deploy the Keycloak PostgreSQL cluster
Write-Host "Deploying Keycloak PostgreSQL cluster..."
kustomize build --enable-helm ./base/keycloak | kubectl apply -f -

Write-Host "Keycloak PostgreSQL cluster deployment completed."
