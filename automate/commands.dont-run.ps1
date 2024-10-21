
# Use the plugin cnpg to generate the cloudnative operator manifest
kubectl cnpg install generate --watch-namespace $namespace > cnpg_operator.yaml
# This produces the cnpg_operator.yaml file
# To get this command to work the appropriate plugin release needs to be downloaded from  https://github.com/cloudnative-pg/cloudnative-pg/releases
# The output may require to be edited for local use to remove excessively large resource definition metadata blocks

# file can be applied using
kubectl apply -f cnpg_operator.yaml
# See deploy-postgres-cluster.ps1

# The poolers.postgresql.cnpg.io CustomResourceDefinition (CRD). The error states that the metadata annotations size exceeded the allowed limit of 262,144 bytes.
kubectl edit crd poolers.postgresql.cnpg.io
# In the editor, search for the large metadata.annotations field and remove it or reduce its size (look for kubectl.kubernetes.io/last-applied-configuration).
kubectl delete crd poolers.postgresql.cnpg.io

# Check that the PostgreSQL pods are up and running:
kubectl get pods -n cnpg-system

# You can check the status of the PostgreSQL cluster by inspecting the Cluster custom resource:
kubectl get clusters.postgresql.cnpg.io -n cnpg-system

# This command will show the current state of the PostgreSQL cluster. You can also describe the cluster to get detailed information:
kubectl describe cluster cluster-example -n cnpg-system

# Port Forward the PostgreSQL Service
# kubectl port-forward -n cnpg-system svc/cluster-example 5432:5432
kubectl port-forward -n cnpg-system svc/cluster-example-rw 5432:5432

# 
kubectl get secret -n cnpg-system 

# NAME                          TYPE                       DATA   AGE
# cluster-example-app           kubernetes.io/basic-auth   9      19m
# cluster-example-ca            Opaque                     2      19m
# cluster-example-replication   kubernetes.io/tls          2      19m
# cluster-example-server        kubernetes.io/tls          2      19m
# cluster-example-superuser     kubernetes.io/basic-auth   9      19m
# cnpg-ca-secret                Opaque                     2      19m
# cnpg-webhook-cert             kubernetes.io/tls          2      19m

# The secret cluster-example-superuser was created, which likely contains the credentials for the postgres superuser.
# You can now retrieve the password for the postgres user from the cluster-example-superuser secret.
# To confirm the superuser username (which is likely postgres), you can also retrieve the username from the secret:
$encodedUsername = kubectl get secret cluster-example-superuser -n cnpg-system -o jsonpath="{.data.username}"
$decodedUsername = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedUsername))
Write-Host "PostgreSQL superuser username: $decodedUsername"

# OUTPUT: PostgreSQL superuser username: postgres

psql -h localhost -U postgres -d postgres -p 5432

# Run the following PowerShell command to retrieve and decode the password for the postgres user:

$encodedPassword = kubectl get secret cluster-example-superuser -n cnpg-system -o jsonpath="{.data.password}"
$decodedPassword = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($encodedPassword))
Write-Host "PostgreSQL superuser password: $decodedPassword"

