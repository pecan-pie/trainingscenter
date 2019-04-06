#!/bin/bash

#
# Raw-Cluster
#
terraform init
terraform apply -auto-approve

# setup kubeconfig
export KUBECONFIG=$(pwd)/trainingscenter.yaml

#
# Networking
# HINT: helm template ....
kubectl create ns istio-system
kubectl apply -f istio/istio-init.yaml

# wait for batchjobs to complete
sleep 60

kubectl apply -f istio/istio-kiali-secret.yaml
kubectl apply -f istio/istio.yaml
kubectl label namespace default istio-injection=enabled

#
# Expose services over istio ingress gateway
#
kubectl apply -f istio/services.yaml
