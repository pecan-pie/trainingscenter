resource "helm_release" "jenkins" {
  name  = "jenkins"
  chart = "stable/jenkins"
  
  values = ["${file("jenkins-values.yml")}"]

  set {
    name  = "master.ingress.hostName"
    value = "jenkins.${var.domain}"
  }

  depends_on = ["kubernetes_cluster_role_binding.tiller", "kubernetes_service_account.tiller"]
}