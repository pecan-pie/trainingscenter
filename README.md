# Requirements

* kubectl
* terraform
* helm
* linkerd

# Setup

```
export KUBECONFIG=contexts/kube-cluster-trainingscenter.yaml

terraform init
terraform apply -var do_token=${DIGITAL_OCEAN_TOKEN} -var acme_mail=recipient@sample.com -var domain=sample.com

# List all created resources
kubectl get all --all-namespaces

# Connect to Linkerd dashboard
linkerd dashboard &
```
