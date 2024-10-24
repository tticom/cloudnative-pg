#!/bin/bash

# Deploy the DICOM PostgreSQL cluster
echo "Deploying DICOM PostgreSQL cluster..."
kustomize build --enable-helm ./base/dicom | kubectl apply --server-side --force-conflicts -f -

echo "DICOM deployment completed."
