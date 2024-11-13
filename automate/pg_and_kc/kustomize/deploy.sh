
# Create the namespace
kubectl apply -f ./namespace.yaml

# Deploy the operator
kustomize build --enable-helm ./operator | kubectl apply -f -

