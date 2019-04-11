resource "digitalocean_domain" "default" {
  name = "${var.domain}"
}

resource "digitalocean_record" "traefik" {
  domain = "${digitalocean_domain.default.name}"
  type   = "A"
  name   = "*"
  value  = "${kubernetes_service.trainingscenter.load_balancer_ingress.0.ip}"
}