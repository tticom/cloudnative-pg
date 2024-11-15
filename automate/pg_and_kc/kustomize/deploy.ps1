
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

# Create and install tls certificate and key
# Ref .\operator\keycloak\secret\secrets.ps1
kubectl create secret tls keycloak-tls-secret --cert .\operator\keycloak\secrets\certificate.pem --key .\operator\keycloak\secrets\key.pem

# Create an instance of keycloak
kubectl apply -f .\base\keycloak\keycloak-instance.yaml

# Check the keycloak instance was created
kubectl get keycloaks/keycloak-instance -o go-template='{{range .status.conditions}}CONDITION: {{.type}}{{"\n"}}  STATUS: {{.status}}{{"\n"}}  MESSAGE: {{.message}}{{"\n"}}{{end}}'
kubectl get svc -n default


# Import the realm

