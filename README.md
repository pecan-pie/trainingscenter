# Requirements

* kubectl
* terraform
* helm
* linkerd

# Setup

```
export DIGITAL_OCEAN_TOKEN=<retrieve-digital-ocean-token>
export KUBECONFIG=contexts/kube-cluster-trainingscenter.yaml

# Run Terraform to create infrastructure
terraform init
terraform apply -var do_token=${DIGITAL_OCEAN_TOKEN} -var acme_mail=mail@sample.com -var domain=sample.com

# List all created resources in Kubernetes cluster
kubectl get all --all-namespaces

# Connect to Linkerd dashboard
linkerd dashboard &
```
