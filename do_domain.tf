resource "digitalocean_domain" "default" {
  name = "${var.domain}"
}

resource "null_resource" "traefikip" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig contexts/kube-cluster-${digitalocean_kubernetes_cluster.trainingscenter.name}.yaml get svc traefik -o jsonpath='{ .status.loadBalancer.ingress[0].ip}' > traefikip"
  }

  depends_on = ["helm_release.traefik"]
}

data "local_file" "traefikip" {
  filename   = "${path.module}/traefikip"
  depends_on = ["null_resource.traefikip"]
}

resource "digitalocean_record" "traefik" {
  domain     = "${digitalocean_domain.default.name}"
  type       = "A"
  name       = "*"
  value      = "${data.local_file.traefikip.content}"
  depends_on = ["null_resource.traefikip"]
}
