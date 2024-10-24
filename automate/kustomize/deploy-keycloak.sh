#!/bin/bash

# Deploy the Keycloak PostgreSQL cluster
echo "Deploying Keycloak PostgreSQL cluster..."
kustomize build --enable-helm ./base/keycloak | kubectl apply -f -

echo "Keycloak deployment completed."
