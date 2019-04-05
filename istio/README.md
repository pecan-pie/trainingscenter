https://rinormaloku.com/getting-started-istio/

kubectl create ns istio-systemkubectl apply -f istio.yaml
helm template ../istio/install/kubernetes/helm/istio --name istio --set global.mtls.enabled=false --set tracing.enabled=true --set kiali.enabled=true --set grafana.enabled=true > istio.yaml
kubectl apply -f istio-init.yaml
kubectl apply -f istio.yaml
kubectl label namespace default istio-injection=enabled
