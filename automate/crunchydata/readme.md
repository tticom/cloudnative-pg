# Prereqs
minikube start
minikube addons enable ingress

# starting again
minikube stop
minikube delete

# https://access.crunchydata.com/documentation/postgres-operator/latest/quickstart

kubectl apply -k kustomize/install/namespace
kubectl apply --server-side -k kustomize/install/default

# To check on the status of your installation, you can run the following command
kubectl -n postgres-operator get pods --selector=postgres-operator.crunchydata.com/control-plane=postgres-operator --field-selector=status.phase=Running

#  create a simple Postgres cluster
kubectl apply -k kustomize/blackford

# track the progress of your cluster
kubectl -n postgres-operator describe postgresclusters.postgres-operator.crunchydata.com postgres-cluster

# list the pods created
kubectl get pods -n postgres-operator 

# list the secrets
kubectl get secret --sort-by=.metadata.creationTimestamp -n postgres-operator

# list the configMaps
kubectl get cm --sort-by=.metadata.creationTimestamp -n postgres-operator

# Mutating admission Webhooks
kubectl get Mutatingwebhookconfigurations

# CRDs
kubectl get Customresourcedefinitions 

# Jobs
kubectl get job -n postgres-operator 

# Clusters
kubectl get -n postgres-operator postgrescluster
kubectl describe -n postgres-operator postgrescluster

# Services
kubectl get svc -n postgres-operator

#### PORT FORWARDING ####
# Get the primary pod name
$PG_CLUSTER_PRIMARY_POD=(kubectl get pod -n postgres-operator -o name -l postgres-operator.crunchydata.com/cluster=postgres-cluster,postgres-operator.crunchydata.com/role=master)

# Remove the 'pod/' prefix from the pod name (if necessary)
$PG_CLUSTER_PRIMARY_POD = ($PG_CLUSTER_PRIMARY_POD -replace '^pod/', '')

# Port forward the PostgreSQL primary pod
kubectl -n postgres-operator port-forward $PG_CLUSTER_PRIMARY_POD 5432:5432
#### PORT FORWARDING ####


# Extract secrets

kubectl get secret -n postgres-operator

kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data}" 
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.user}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.dbname}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

kubectl get secret postgres-cluster-pguser-keycloak-admin -n postgres-operator -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
kubectl get secret postgres-cluster-pguser-keycloak-admin -n postgres-operator -o jsonpath="{.data.user}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }



# $env:PG_CLUSTER_USER_SECRET_NAME="postgres-cluster-pguser-postgres-cluster"

# PGPASSWORD
# kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.password | base64decode}}'
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

# PGUSER
# kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.user | base64decode}}'
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.user}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

# PGDATABASE
# kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.dbname | base64decode}}'
kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.dbname}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }

# PGPASSWORD=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.password | base64decode}}') \ 
# PGUSER=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.user | base64decode}}') \ 
# PGDATABASE=$(kubectl get secrets -n postgres-operator "${PG_CLUSTER_USER_SECRET_NAME}" -o go-template='{{.data.dbname | base64decode}}') \ 

#### Connect to the database ####
$env:PGPASSWORD=(kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) })
$env:PGUSER=(kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.user}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }) 
$env:PGDATABASE=(kubectl get secret postgres-cluster-pguser-postgres -n postgres-operator -o jsonpath="{.data.dbname}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }) 

psql -h localhost

#### Connect to the database ####

CREATE SCHEMA blackford AUTHORIZATION superuser;


# Create a config map
kubectl -n postgres-operator create configmap postgres-db-init-sql --from-file=init.sql=.\init.sql
kubectl -n postgres-operator create configmap postgres-db-init-sql --from-file=init.sql=.\kustomize\blackford\init.sql --dry-run=client -o yaml | kubectl apply -f -


# Get the primary pod name
$PG_CLUSTER_PRIMARY_POD=(kubectl get pod -n postgres-operator -o name -l postgres-operator.crunchydata.com/cluster=postgres-cluster,postgres-operator.crunchydata.com/role=master)
# Remove the 'pod/' prefix from the pod name (if necessary)
$PG_CLUSTER_PRIMARY_POD = ($PG_CLUSTER_PRIMARY_POD -replace '^pod/', '')
kubectl exec -it $PG_CLUSTER_PRIMARY_POD -n postgres-operator -- psql -U superuser -f .\kustomize\blackford\init.sql

kubectl exec -it $PG_CLUSTER_PRIMARY_POD -n postgres-operator -- /bin/bash
