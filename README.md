# Trainingscenter

This repository contains the resources for the Trainingscenter project. Purpose of this project is giving developers a way of learning to work with Kubernetes and applications running on the platform. The sources in this project provision a Kubernetes cluster on DigitalOcean with Linkerd, ExternalDNS and Traefik running on it. These tools are a sensible baseline for developers to get started working on Kubernetes.   

# Get Started 

## Requirements

* kubectl
* terraform
* helm
* linkerd
  
## Run it

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

## Reference guide

| Option        | Usage                 |
| ------------- |:---------------------:|
| do_token      |                       |
| domain        |                       |
| acme_mail     |                       |

# Contributing