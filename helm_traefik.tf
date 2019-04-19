resource "helm_release" "traefik" {
  name   = "traefik"
  chart  = "stable/traefik"
  values = ["${file("traefik-values.yml")}"]

  set {
    name  = "dashboard.domain"
    value = "traefik.${var.domain}"
  }

  set {
    name  = "acme.email"
    value = "${var.acme_mail}"
  }

  set {
    name  = "acme.dnsProvider.digitalocean.DO_AUTH_TOKEN"
    value = "${var.do_token}"
  }

  depends_on = ["kubernetes_cluster_role_binding.tiller"]
}
