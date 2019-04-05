variable "do_token" {
  type    = "string"
  default = "123456"
}

/*
    domain wich is used for the cluster
*/
variable "domain" {
  type    = "string"
  default = "example.com"
}

/*
    domain wich is used for the cluster
*/
variable "acme_mail" {
  type    = "string"
  default = "info@example.com"
}

/*
    initialize do provider
*/
provider "digitalocean" {
  token = "${var.do_token}"
}

/*
    create the kuberntes cluster on digitalocean
*/
resource "digitalocean_kubernetes_cluster" "trainingscenter" {
  name    = "trainingscenter"
  region  = "fra1"
  version = "1.13.5-do.1"
  tags    = ["staging"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

/*
 initialize the kuberntes provider for inititial setups
*/
provider "kubernetes" {
  // don´t use a local kubeconfig
  load_config_file = false

  // use a custom configuration, so we have no trouble with existing configurations
  host = "${digitalocean_kubernetes_cluster.trainingscenter.endpoint}"

  client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.cluster_ca_certificate)}"
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

    client_certificate     = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.trainingscenter.kube_config.0.cluster_ca_certificate)}"
    load_config_file       = false
  }

  service_account = "tiller"
  install_tiller  = true
}

resource "helm_release" "traefik" {
  name  = "traefik"
  chart = "stable/traefik"

  set {
    name  = "serviceType"
    value = "LoadBalancer"
  }

  set {
    name  = "dashboard.enabled"
    value = "true"
  }

  set {
    name  = "dashboard.domain"
    value = "traefik.${var.domain}"
  }

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}

resource "helm_release" "jenkins" {
  name  = "jenkins"
  chart = "stable/jenkins"

  set {
    name  = "Master.ServiceType"
    value = "ClusterIP"
  }

  set {
    name  = "Master.ingress.enabled"
    value = "true"
  }

  set {
    name  = "Master.ingress.hostName"
    value = "jenkins.${var.domain}"
  }
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
