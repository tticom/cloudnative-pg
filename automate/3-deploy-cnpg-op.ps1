# deploy-cloudnativepg-operator.ps1
# This script downloads and deploys the pre-built CloudNativePG operator using PowerShell

# Set your desired namespace here
$namespace = "cnpg-system"

# Define the URL for the pre-built CloudNativePG operator YAML
$operatorYamlUrl = "https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.24/releases/cnpg-1.24.1.yaml"

# Check if the namespace exists, and create it if it doesn't
if (-not (kubectl get namespace $namespace)) {
    Write-Host "Creating namespace $namespace..."
    kubectl create namespace $namespace

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to create namespace $namespace."
        exit 1
    }
    Write-Host "Namespace $namespace created successfully."
} else {
    Write-Host "Namespace $namespace already exists."
}

# Download and apply the CloudNativePG operator YAML
# Use a local edited manifest file as the metadata in the downloaded one exceeds kebernetes limits
Write-Host "Applying the CloudNativePG operator YAML from $operatorYamlUrl..."
#kubectl apply -f $operatorYamlUrl
kubectl apply -f .\cnpg_operator.yaml

if ($LASTEXITCODE -eq 0) {
    Write-Host "CloudNativePG operator deployed successfully in namespace $namespace."
} else {
    Write-Host "Failed to deploy CloudNativePG operator."
    exit 1
}
