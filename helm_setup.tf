resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "tiller"
    namespace = "default"
  }

  depends_on = [
    local_file.kube_config,
    null_resource.linkerd,
  ]
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
    namespace = "default"
  }

  # Ensure that config is existent upon creation and destruction of cluster.
  depends_on = [
    local_file.kube_config,
    null_resource.linkerd,
  ]
}

provider "helm" {
  kubernetes {
    host = digitalocean_kubernetes_cluster.trainingscenter.endpoint

    client_certificate = base64decode(
      digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].client_certificate,
    )

    client_key = base64decode(
      digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].client_key,
    )
    
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.trainingscenter.kube_config[0].cluster_ca_certificate,
    )

    load_config_file = false
  }

  service_account = "tiller"
  namespace       = "default"
  install_tiller  = true
}

