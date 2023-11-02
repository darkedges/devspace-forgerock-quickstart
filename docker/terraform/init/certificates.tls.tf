resource "vault_pki_secret_backend_cert" "localhost" {
  depends_on = [vault_pki_secret_backend_role.backend_role_idam]
  for_each = { for idx, record in local.helper_list : idx => record }

  backend = vault_mount.pki_intermediate.path
  name = vault_pki_secret_backend_role.backend_role_idam.name

  common_name = each.value.config.common_name
  alt_names = lookup(each.value.config, "alt_names", [])
  ip_sans = ["127.0.0.1"]
}

resource "local_file" "ca_chain" {
  for_each = { for idx, record in local.helper_list : idx => record }
  content  = format("%s\n%s",vault_pki_secret_backend_cert.localhost[each.key].certificate,vault_pki_secret_backend_cert.localhost[each.key].issuing_ca) 
  filename = "/mnt/secrets/${each.value.service}/${each.value.certificate}.crt"
}

resource "local_file" "private_key" {
  for_each = { for idx, record in local.helper_list : idx => record }
  content  = vault_pki_secret_backend_cert.localhost[each.key].private_key
  filename = "/mnt/secrets/${each.value.service}/${each.value.certificate}.key"
}