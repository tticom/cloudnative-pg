
# Create the namespace
kubectl apply -f ./namespace.yaml
kubectl apply -f ./base/dicom/namespace.yaml
kubectl apply -f ./base/keycloak/namespace.yaml

# Deploy the operator
kustomize build --enable-helm .\operator | kubectl --server-side --force-conflicts --validate=false apply -f -

# --server-side flag mitigates issues with long content in the crd file.

# # Deploy the DICOM PostgreSQL cluster
# Write-Host "Deploying DICOM PostgreSQL cluster..."
# kustomize build --enable-helm ./base/dicom | kubectl apply --server-side --force-conflicts -f -

# Write-Host "DICOM PostgreSQL cluster deployment completed."

# # Deploy the Keycloak PostgreSQL cluster
# Write-Host "Deploying Keycloak PostgreSQL cluster..."
# kustomize build --enable-helm ./base/keycloak | kubectl apply -f -

# Write-Host "Keycloak PostgreSQL cluster deployment completed."

