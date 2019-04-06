resource "kubernetes_service" "trainingscenter" {
  metadata {
    name = "traefik-lb"
    namespace = "default"
  }

  spec {
    selector {
      "app" = "traefik"
      "release" = "traefik"
    }

    port {
      name = "http"
      port = 80
      target_port = "http"
    }

    port {
      name = "https"
      port = 443
      target_port = "https"
    }

    type = "LoadBalancer"
    session_affinity = "ClientIP"
  }

  depends_on = [ "local_file.kube_config"]
}