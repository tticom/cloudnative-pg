# This script installs the CloudNativePG CRDs

Write-Host "Installing CloudNativePG CRDs..."
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.24/releases/cnpg-1.24.1.yaml

if ($LASTEXITCODE -eq 0) {
    Write-Host "CloudNativePG CRDs installed successfully."
} else {
    Write-Host "Failed to install CloudNativePG CRDs."
    exit 1
}
