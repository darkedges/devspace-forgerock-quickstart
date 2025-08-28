provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

resource "kubernetes_namespace" "dfq" {
  metadata {
    name = "dfq"
  }
}

resource "kubernetes_secret" "this" {
  for_each = { for idx, record in local.helper_list : idx => record if record.certificate == "tls" }

  metadata {
    name      = each.value.service
    namespace = each.value.config.namespace
  }

  data = {
    "tls.key" = "${vault_pki_secret_backend_cert.localhost[each.key].private_key}"
    "tls.crt" = "${vault_pki_secret_backend_cert.localhost[each.key].certificate}\n"
  }

  type = "kubernetes.io/tls"
} 
