variable "do_token" {
  type    = "string"
  default = "123456"
}

variable "domain" {
  type    = "string"
  default = "test.aidun.de"
}

/*
    initialize do provider
*/
provider "digitalocean" {
  token = "${var.do_token}"
}

/*
 initialize the kuberntes provider for inititial setups
*/
provider "kubernetes" {
  host = "${digitalocean_kubernetes_cluster.trainingscenter.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.cluster_ca_certificate)}"
  load_config_file       = false
}

/*
    create the kuberntes cluster on digitalocean
*/
resource "digitalocean_kubernetes_cluster" "trainingscenter" {
  name    = "trainingscenter"
  region  = "nyc1"
  version = "1.13.5-do.0"

  node_pool {
    name       = "low_end"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}

/*
    create a serviceaccount for helm / tiller
*/
resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "kube-system"
  }
}

/*
    create a clusterrolebinding for tiller
*/
resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"
  }

  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "system:serviceaccounts"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = "kubelet"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = ["digitalocean_kubernetes_cluster.trainingscenter"]
}

/*
    helm provider config
*/
provider "helm" {
  kubernetes {
    host = "${digitalocean_kubernetes_cluster.trainingscenter.endpoint}"

    client_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_certificate)}"
    client_key         = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_key)}"

    //  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.cluster_ca_certificate)}"

    load_config_file = false
  }

  service_account = "tiller"
  install_tiller  = true
}

resource "helm_release" "traefik" {
  name  = "traefik"
  chart = "stable/traefkik"

  values = [
    "${file("traefik.values.yaml")}",
  ]

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

output "kubeconfig" {
  value = "${digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.raw_config}"
}

output "todo" {
  value = <<EOF
    terraform output kubeconfig > trainingscenter.kubeconfig
    export KUBECONFIG=trainingscenter.kubeconfig
    EOF
}
