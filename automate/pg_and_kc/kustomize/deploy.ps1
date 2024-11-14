
# Create the namespace
kubectl apply -f .\namespace.yaml

# Deploy the operator
kustomize build --enable-helm .\operator\cloudnative | kubectl --server-side --force-conflicts --validate=false apply -f -
# --server-side flag mitigates issues with long content in the crd file.

kubectl apply -f .\base\postgres-cluster\postgres-db-secret.yaml
kubectl apply -f .\base\postgres-cluster\postgres-cluster.yaml

# Install the keycloak operator
# Ref .\operator\keycloak\crds.ps1
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# Ref .\operator\keycloak\operator.ps1
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/kubernetes.yml

# Create an instance of keycloak
kubectl -f .\base\keycloak\keycloak-instance.yaml

# Import the realm

