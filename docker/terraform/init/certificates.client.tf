locals {
  clients = {
	  "openidm-admin"= {"provider": "frim", "password": "" }
    "frig"= {"provider": "frig", password: "changeit" }
    "cticookie"= {"provider": "frig", password: "changeit" }
  }
}

resource "vault_pki_secret_backend_cert" "client" {
  depends_on = [vault_pki_secret_backend_role.backend_role_idam]
  for_each = local.clients

  backend = vault_mount.pki_intermediate.path
  name = vault_pki_secret_backend_role.backend_role_idam.name

  common_name = "${each.key}"
}

resource "pkcs12_from_pem" "client" {
  for_each         = local.clients
  password         = local.clients[each.key].password
  cert_pem         = vault_pki_secret_backend_cert.client[each.key].certificate
  private_key_pem  = vault_pki_secret_backend_cert.client[each.key].private_key
  ca_pem           = vault_pki_secret_backend_cert.client[each.key].ca_chain
}

resource "local_file" "client" {
  for_each        = local.clients
  filename        = "/mnt/secrets/${local.clients[each.key].provider}/${each.key}.p12"
  content_base64  = pkcs12_from_pem.client[each.key].result
}