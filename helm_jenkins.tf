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