#!/bin/bash

#
# Raw-Cluster
#
terraform apply -auto-approve

# setup kubeconfig
terraform output kubeconfig > trainingscenter.kubeconfig
export KUBECONFIG=$(pwd)/trainingscenter.kubeconfig

#
# Networking
# HINT: helm template ....
kubectl apply -f istio/istio-init.yaml
kubectl apply -f istio/istio.yaml

#
# Ingress gateway
#
kubectl apply -f istio/istio-gateway.yaml

#
# Expose services over istio ingress gateway
#
kubectl apply -f istio/services.yaml