
# Install CRDs

kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml

# Create an instance of keycloak
kubectl apply -f https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.0.5/kubernetes/kubernetes.yml
