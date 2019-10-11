resource "tls_private_key" "linkerd" {
  algorithm = "ECDSA"
}

resource "tls_self_signed_cert" "linkerd" {
  key_algorithm   = "${tls_private_key.linkerd.algorithm}"
  private_key_pem = "${tls_private_key.linkerd.private_key_pem}"

  # Certificate expires after 12 hours.
  validity_period_hours = 240

  allowed_uses = [
      "key_encipherment",
      "digital_signature",
      "server_auth",
  ]

  dns_names = ["identity.linkerd.cluster.local"]

  subject {
      common_name  = "identity.linkerd.cluster.local"
      organization = "Trainingscenter"
  }
}

resource "helm_release" "linkerd" {
  name  = "linkerd"
  chart = "linkerd/linkerd2"

  set {
    name  = "Identity.TrustAnchorsPem"
    value = "${tls_private_key.linkerd.private_key_pem}"
  }

  set {
    name = "Identity.Issuer.TLS.CrtPEM"
    value = "${tls_self_signed_cert.linkerd.cert_pem}"
  }

  set {
    name = "Identity.Issuer.TLS.KeyPEM"
    value = "${tls_private_key.linkerd.private_key_pem}"
  }

  set {
    name = "Identity.Issuer.CrtExpiry"
    value = "${tls_self_signed_cert.linkerd.validity_end_time}"
  }

  depends_on = [
    kubernetes_cluster_role_binding.tiller,
    kubernetes_service_account.tiller,
  ]
}
