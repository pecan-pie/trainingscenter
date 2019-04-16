# Requirements
## Mandatory
* kubectl
* terraform
* helm
* linkerd
## Optional
* kubefwd
* kube-prompt

# Setup
```
terraform init
terraform apply

export KUBECONFIG=contexts/kube-cluster-trainingscenter.yaml

kubectl get all --all-namespaces

linkerd dashboard &
```
