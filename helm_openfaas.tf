# ref: https://github.com/openfaas-incubator/openfaas-operator#get-started
data "helm_repository" "openfaas_repository" {
  name = "openfaas_repository"
  url  = "https://openfaas.github.io/faas-netes/"
}

resource "null_resource" "openfaas_namespaces" {

  provisioner "local-exec" {
      command = "kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl -n openfaas create secret generic basic-auth --from-literal=basic-auth-user=admin --from-literal=basic-auth-password=\"$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)\" --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl annotate namespace openfaas \"linkerd.io/inject=enabled\" --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl annotate namespace openfaas-fn \"linkerd.io/inject=enabled\" --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml"
  }
  
  depends_on = [null_resource.linkerd]
}

resource "helm_release" "openfaas" {

  name       = "openfaas"
  repository = data.helm_repository.openfaas_repository.metadata[0].name
  chart      = "openfaas"
  namespace  = "openfaas"

  values = [file("openfaas-values.yml")]

  set {
    name  = "ingress.hosts[0].host"
    value = "openfaas.${var.domain}"
  }

  depends_on = [null_resource.openfaas_namespaces]
}