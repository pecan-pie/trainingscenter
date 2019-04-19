resource "null_resource" "linkerd" {
  provisioner "local-exec" {
    command = "linkerd install --proxy-auto-inject | kubectl --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml apply -f -"
  }

  # helm_release.traefik becouse traefik should not be part of the service mesh
  # maybe we can add it, but you have to remember it always: https://linkerd.io/2/tasks/using-ingress/#traefik
  depends_on = ["digitalocean_kubernetes_cluster.trainingscenter", "helm_release.traefik"]
}
