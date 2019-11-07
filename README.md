# Trainingscenter

This repository contains resources for the Trainingscenter project. Purpose of this project is giving developers a quick way to learn working with Kubernetes and the Infrastructure-as-code part around it. The sources in this project provision a Kubernetes cluster on DigitalOcean with Linkerd, ExternalDNS and Traefik running on it. These tools are a sensible baseline for developers to get started working on Kubernetes.   

# Get Started 

## Prerequisites

Make sure the following command line tools are installed on your machine. All binaries have to be included in the `PATH` variable.

* kubectl
* terraform
* helm
* linkerd
  
## Run it

```bash
# Prepare Environment Variables for the installation
export DIGITAL_OCEAN_TOKEN=<retrieve-digital-ocean-token>
export KUBECONFIG=contexts/kube-cluster-trainingscenter.yaml

# Run Terraform to create infrastructure
terraform init
terraform apply -var do_token=${DIGITAL_OCEAN_TOKEN} -var acme_mail=mail@sample.com -var domain=sample.com
```

## Use It

After setting up the infrastructure on DigitalOcean you can access it via the following commands.

### via CLI

```bash
# List all resources in the Kubernetes cluster
kubectl get all --all-namespaces

# Connect to the Linkerd dashboard (make sure linkerd binary is available)
linkerd dashboard &
```

### via HTTP

The following subdomains will be accesible from outside the cluster:
* `traefik.sample.com`
 
