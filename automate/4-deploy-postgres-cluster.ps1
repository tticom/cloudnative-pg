# This script creates a 3-node PostgreSQL cluster using CloudNativePG

Write-Host "Creating PostgreSQL cluster..."
$clusterYaml = @"
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: cluster-example
  namespace: cnpg-system
spec:
  instances: 3
  storage:
    size: 1Gi
"@

$clusterYaml | kubectl apply -f -

if ($LASTEXITCODE -eq 0) {
    Write-Host "PostgreSQL cluster created successfully."
} else {
    Write-Host "Failed to create PostgreSQL cluster."
    exit 1
}
