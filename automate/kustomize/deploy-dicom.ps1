# Deploy the DICOM PostgreSQL cluster
Write-Host "Deploying DICOM PostgreSQL cluster..."
kustomize build --enable-helm ./base/dicom | kubectl apply --server-side --force-conflicts -f -

Write-Host "DICOM PostgreSQL cluster deployment completed."
