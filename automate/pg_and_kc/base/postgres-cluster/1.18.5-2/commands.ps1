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

------------------------------------------------

# Troubleshooting
# kubectl get pods -n postgres
# kubectl get svc -n postgres

# kubectl get cluster -n postgres
# NAME       AGE    INSTANCES   READY   STATUS                     PRIMARY
# postgres   110s   3           3       Cluster in healthy state   postgres-1

# kubectl get pods -n postgres
# NAME                     READY   STATUS    RESTARTS   AGE
# create-databases-9mkp9   0/1     Error     0          3m32s
# create-databases-k4nvb   0/1     Error     0          2m9s
# create-databases-x7rqv   0/1     Error     0          69s
# create-databases-xmgd2   0/1     Error     0          109s
# postgres-1               1/1     Running   0          3m14s
# postgres-2               1/1     Running   0          2m56s
# postgres-3               1/1     Running   0          2m48s

# kubectl logs -n postgres create-databases-9mkp9
# psql: error: connection to server at "postgres-rw.postgres.svc.cluster.local" (10.99.149.107), port 5432 failed: FATAL:  password authentication failed for user "postgres"
# connection to server at "postgres-rw.postgres.svc.cluster.local" (10.99.149.107), port 5432 failed: FATAL:  password authentication failed for user "postgres"

# kubectl get secret postgres-secret -n postgres -o yaml
# apiVersion: v1
# data:
#   password: cG9zdGdyZXM=
# kind: Secret
# metadata:
#   annotations:
#     kubectl.kubernetes.io/last-applied-configuration: |
#       {"apiVersion":"v1","data":{"password":"cG9zdGdyZXM="},"kind":"Secret","metadata":{"annotations":{},"name":"postgres-secret","namespace":"postgres"},"type":"Opaque"}
#   creationTimestamp: "2024-11-29T13:12:43Z"
#   name: postgres-secret
#   namespace: postgres
#   resourceVersion: "544"
#   uid: 4ed47aaa-a5ba-4402-bb57-01b720043102
# type: Opaque

# $encodedPassword = "UGFzc3dvcmQxMjM="
# [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedPassword))
# Password123


# kubectl delete secret postgres-secret -n postgres
# kubectl create secret generic postgres-secret -n postgres --from-literal=password='postgres'
# kubectl delete pod -n postgres create-databases-9mkp9
# kubectl delete pod -n postgres create-databases-k4nvb
# kubectl delete pod -n postgres create-databases-x7rqv
# kubectl delete pod -n postgres create-databases-xmgd2

# kubectl get all -n postgres

# NAME             READY   STATUS    RESTARTS   AGE
# pod/postgres-1   1/1     Running   0          33m
# pod/postgres-2   1/1     Running   0          33m
# pod/postgres-3   1/1     Running   0          32m

# NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# service/postgres-r    ClusterIP   10.106.54.99    <none>        5432/TCP   34m
# service/postgres-ro   ClusterIP   10.104.107.59   <none>        5432/TCP   34m
# service/postgres-rw   ClusterIP   10.99.149.107   <none>        5432/TCP   34m

# NAME                         STATUS   COMPLETIONS   DURATION   AGE
# job.batch/create-databases   Failed   0/1           33m        33m

kubectl delete job create-databases -n postgres --ignore-not-found
kubectl apply -f create-databases.yaml

# 
# 

kubectl logs -n postgres create-databases-7dcts
kubectl logs -n postgres create-databases-cjnt6 
kubectl logs -n postgres create-databases-m98lr 
kubectl logs -n postgres create-databases-wh8rf 


kubectl run postgres-client -n postgres --rm -it --image=postgres:15 -- psql -h postgres-rw.postgres.svc.cluster.local -U postgres


