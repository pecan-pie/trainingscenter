resource "digitalocean_kubernetes_cluster" "trainingscenter" {
  name    = "trainingscenter"
  region  = "fra1"
<<<<<<< HEAD
  version = "1.15.4-do.0"
=======
  version = "1.15.3-do.3"
>>>>>>> Set Cluster Version to 1.15.3
  tags    = ["staging"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 3
  }
}

resource "local_file" "kube_config" {
  content  = digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].raw_config
  filename = "contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"
}

provider "kubernetes" {
  // Don't load existing config files. We use a separate config file just for this cluster.
  load_config_file = false
  host             = digitalocean_kubernetes_cluster.trainingscenter.endpoint
  token            = digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].token

  client_certificate = base64decode(
    digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].client_certificate,
  )

  client_key = base64decode(
    digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].client_key,
  )
  
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].cluster_ca_certificate,
  )
}