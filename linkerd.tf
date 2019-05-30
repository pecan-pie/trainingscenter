resource "null_resource" "linkerd" {
  provisioner "local-exec" {
    command = "linkerd install --proxy-auto-inject --kubeconfig contexts/kube-cluster-trainingscenter.yaml | kubectl --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml apply -f -"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml annotate namespace default linkerd.io/inject=enabled --overwrite"
  }

  provisioner "local-exec" {
    command = "kubectl --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml wait --for=condition=Ready pods --all --namespace linkerd --timeout=240s"
  }

  # Ensure that config is existent upon installation of linkerd
  depends_on = ["local_file.kube_config"]
}
