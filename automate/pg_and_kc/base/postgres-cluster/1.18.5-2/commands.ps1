kubectl apply -f cnpg-1.18.5.yaml
kubectl apply -f namespace.yaml
kubectl apply -f secrets.yaml
kubectl apply -f pv-pvc.yaml
kubectl apply -f postgres-cluster.yaml
kubectl apply -f create-databases.yaml
kubectl logs -n postgres job/create-databases

# Test the connections
# Keycloak database
kubectl run -n postgres postgres-client --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U keycloak_admin -d keycloak

# DICOM Store database
kubectl run -n postgres postgres-client --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U dicom_admin -d dicom_store
