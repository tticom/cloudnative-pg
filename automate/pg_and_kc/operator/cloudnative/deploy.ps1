# https://cloudnative-pg.io/documentation/1.18/installation_upgrade/

# You can install the latest operator manifest for this minor release as follows
# N.B. Note the release is 1.18 - Current at time of writing is 1.24.1
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.18/releases/cnpg-1.18.5.yaml
# https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/refs/heads/release-1.24/releases/cnpg-1.24.1.yaml

# verify with:
kubectl get deploy -n cnpg-system cnpg-controller-manager

# get more information using the describe command in
# kubectl get deployments -n cnpg-system
# kubectl describe deploy -n cnpg-system <deployment-name>
# kubectl describe deploy -n cnpg-system cnpg-controller-manager 

# https://cloudnative-pg.io/documentation/1.18/quickstart/#part-2-install-cloudnativepg

# Apply the cluster manifest in base\postgres-cluster\postgres-cluster.yaml
kubectl apply -f ..\..\base\postgres-cluster\postgres-cluster.yaml

# kubectl get pods

# https://cloudnative-pg.io/documentation/1.18/connection_pooling/
# kubectl get namespaces
# namespace created by the cloudnative operator
# kubectl get pods -n cnpg-system

# All other pods should be in default
# kubectl get pods -n default

# The Pooler must live in the same namespace of the Postgres cluster
# If you specify your own secrets the operator will not automatically integrate the Pooler.

kubectl apply -f ..\..\base\postgres-cluster\pooler.yaml

# kubectl exec -ti <PGBOUNCER_POD> -- curl 127.0.0.1:9127/metrics
# kubectl exec -ti pooler-postgres-db-cluster-rw-f59cbd8d7-tqsjg -- curl 127.0.0.1:9127/metrics
# kubectl exec -ti pooler-postgres-db-cluster-rw-f59cbd8d7-w4kq2 -- curl 127.0.0.1:9127/metrics
# kubectl exec -ti pooler-postgres-db-cluster-rw-f59cbd8d7-j2sls -- curl 127.0.0.1:9127/metrics