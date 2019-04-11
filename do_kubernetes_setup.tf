/*
    create the kubernetes cluster on digitalocean
*/
resource "digitalocean_kubernetes_cluster" "trainingscenter" {
  name    = "trainingscenter"
  region  = "fra1"
  version = "1.13.5-do.1"
  tags    = ["staging"]

  node_pool {
    name       = "worker-pool"
    size       = "s-4vcpu-8gb"
    node_count = 3
  }
}

/*
 initialize the Kubernetes provider for inititial setups
*/
provider "kubernetes" {
  // don't use a local kubeconfig
  load_config_file = false

  // use a custom configuration, so we have no trouble with existing configurations
  host = "${digitalocean_kubernetes_cluster.trainingscenter.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.cluster_ca_certificate)}"
}

resource "local_file" "kube_config" {
  content  = "${digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.raw_config}"
  filename = "contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"

  # TODO: Append this file to KUBECONFIG environment variable?
}
