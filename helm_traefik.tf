resource "helm_release" "traefik" {
  name  = "traefik"
  chart = "stable/traefik"

  set {
    name  = "serviceType"
    value = "NodePort"
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