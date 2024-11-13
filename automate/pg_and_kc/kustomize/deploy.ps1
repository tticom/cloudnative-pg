
# Create the namespace
kubectl apply -f .\namespace.yaml

# Deploy the operator
kustomize build --enable-helm .\operator\cloudnative | kubectl --server-side --force-conflicts --validate=false apply -f -

# --server-side flag mitigates issues with long content in the crd file.
