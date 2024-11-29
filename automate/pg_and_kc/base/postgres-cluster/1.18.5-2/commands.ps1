kubectl apply -f cnpg-1.18.5.yaml
kubectl apply -f namespace.yaml
kubectl apply -f secrets.yaml
kubectl apply -f pv-pvc.yaml
kubectl apply -f postgres-cluster.yaml
kubectl apply -f create-databases.yaml

# Verify the cluster resource
kubectl get cluster -n postgres

# Confirm that the associated pods and services are created
kubectl get pods -n postgres
kubectl get svc -n postgres

# Monitor logs to ensure successful execution
kubectl logs -n postgres job/create-databases

#Check Cluster Resource Verify the cluster is created successfully
kubectl get cluster -n postgres

# Verify database creation
kubectl run -n postgres postgres-client --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U postgres -c "\l"

# Test the connections
# Keycloak database
kubectl run -n postgres postgres-client --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U keycloak_admin -d keycloak

# DICOM Store database
kubectl run -n postgres postgres-client --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U dicom_admin -d dicom_store




# Check DNS Resolution
# Run a debug pod
kubectl run dns-test -n postgres --rm -it --image=busybox -- nslookup postgres-rw.postgres.svc.cluster.local

# DNS Issues: If DNS lookups fail (postgres-rw.postgres.svc.cluster.local), restart the coredns pods
kubectl rollout restart deployment -n kube-system coredns

# Verify that the DNS issue is resolved
kubectl run dns-test -n postgres --rm -it --image=busybox -- nslookup postgres-rw.postgres.svc.cluster.local


# Reapply the Database Creation Job
# After ensuring the cluster and DNS are functioning:

# Delete the existing failing job:

kubectl delete job -n postgres create-databases

# Reapply the create-databases.yaml:

kubectl apply -f create-databases.yaml

# Monitor the job logs:

kubectl logs -n postgres job/create-databases

# Common Checks
# Cluster Resource Missing: If 
kubectl get cluster -n postgres 
# returns no resources, ensure the postgres-cluster.yaml is correctly defined and applied.
# Namespace Issue: Verify that all resources are deployed in the postgres namespace:

kubectl get all -n postgres
