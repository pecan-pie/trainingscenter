# ref: https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd
data "helm_repository" "argo" {
  name = "argo"
  url  = "https://argoproj.github.io/argo-helm"
}

#
# ref: https://github.com/terraform-providers/terraform-provider-helm/issues/102
resource "helm_release" "argocd" {
  name  = "argocd"
  chart = "argo/argo-cd"
  version = "0.5.4"

  values = [file("values-argocd.yml")]

  depends_on = [kubernetes_cluster_role_binding.tiller]
}