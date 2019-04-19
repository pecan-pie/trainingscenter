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
