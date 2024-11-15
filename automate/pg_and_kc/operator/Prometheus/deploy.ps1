# From https://cloudnative-pg.io/documentation/1.18/quickstart/#part-2-install-cloudnativepg

# add the prometheus-community helm chart repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# install the Kube Prometheus stack
helm upgrade --install -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/kube-stack-config.yaml prometheus-community prometheus-community/kube-prometheus-stack

# To access Prometheus, port-forward the Prometheus service
# kubectl port-forward svc/prometheus-community-kube-prometheus 9090

# define some alerts by creating a prometheusRule
# kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/main/docs/src/samples/monitoring/cnpg-prometheusrule.yaml
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/refs/heads/main/docs/src/samples/monitoring/prometheusrule.yaml

# See the prometheus rules
kubectl get prometheusrules  

# Grafana is deployed with no predefined dashboards.
# kubectl port-forward svc/prometheus-community-grafana 3000:80
# access Grafana locally at http://localhost:3000/ providing the credentials 
# admin as username, prom-operator as password (defined in kube-stack-config.yaml).

# We can now install our sample Grafana dashboard:
# kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/refs/heads/main/docs/src/samples/monitoring/grafana-configmap.yaml
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/refs/heads/release-1.19/docs/src/samples/monitoring/grafana-configmap.yaml