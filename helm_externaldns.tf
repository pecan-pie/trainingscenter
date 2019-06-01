resource "helm_release" "external-dns" {
  name    = "external-dns"
  chart   = "stable/external-dns"
  version = "1.7.8"

  set {
    name  = "digitalocean.apiToken"
    value = var.do_token
  }

  set {
    name  = "provider"
    value = "digitalocean"
  }

  set {
    name  = "source"
    value = "ingress"
  }

  depends_on = [kubernetes_cluster_role_binding.tiller]
}

