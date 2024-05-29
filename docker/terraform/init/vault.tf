variable "namespace" {
  type    = string
  default = "dfq"
}

variable "vaulturl" {
  type    = string
  default = "http://vault.dfq.localdev:8200"
}

variable "allowed_domains" {
  type    = list(string)
  default = ["dfq"]
}

variable "organisation" {
  type    = string
  default = "dfq"
}

variable "country" {
  type    = string
  default = "AU"
}

variable "locality" {
  type    = string
  default = "Melbourne"
}

variable "ou" {
  type    = string
  default = "IDAM"
}

resource "vault_mount" "pki_root" {
  path                      = "${var.namespace}_idam_root"
  type                      = "pki"
  description               = "This is an pki_root mount"
  default_lease_ttl_seconds = "315360000"
  max_lease_ttl_seconds     = "315360000"
}

resource "vault_mount" "pki_intermediate" {
  path                      = "${var.namespace}_idam_intermediate"
  type                      = "pki"
  description               = "This is an pki_intermediate mount"
  default_lease_ttl_seconds = "31536000"
  max_lease_ttl_seconds     = "31536000"
}

resource "vault_pki_secret_backend_config_urls" "idam_root_config_urls" {
  backend                 = vault_mount.pki_root.path
  crl_distribution_points = ["${var.vaulturl}/v1/${vault_mount.pki_root.path}/crl"]
  issuing_certificates    = ["${var.vaulturl}/v1/${vault_mount.pki_root.path}/ca"]
}

resource "vault_pki_secret_backend_config_urls" "idam_intermediate_config_urls" {
  backend                 = vault_mount.pki_intermediate.path
  crl_distribution_points = ["${var.vaulturl}/v1/${vault_mount.pki_intermediate.path}/crl"]
  issuing_certificates    = ["${var.vaulturl}/v1/${vault_mount.pki_intermediate.path}/ca"]
}

resource "vault_pki_secret_backend_root_cert" "root" {
  depends_on           = [vault_mount.pki_root]
  backend              = vault_mount.pki_root.path
  type                 = "internal"
  common_name          = "${var.organisation} ${var.ou} Root"
  ttl                  = "315360000"
  format               = "pem"
  private_key_format   = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  ou                   = var.ou
  organization         = var.organisation
  country              = var.country
  locality             = var.locality
}

resource "vault_pki_secret_backend_intermediate_cert_request" "intermediate" {
  depends_on  = [vault_mount.pki_intermediate]
  backend     = vault_mount.pki_intermediate.path
  type        = "internal"
  common_name = "${var.organisation} Intermediate"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "intermediate" {
  depends_on           = [vault_pki_secret_backend_intermediate_cert_request.intermediate]
  backend              = vault_mount.pki_root.path
  csr                  = vault_pki_secret_backend_intermediate_cert_request.intermediate.csr
  common_name          = "${var.organisation} ${var.ou} Intermediate"
  exclude_cn_from_sans = true
  ou                   = var.ou
  organization         = var.organisation
}

resource "vault_pki_secret_backend_intermediate_set_signed" "intermediate" {
  backend     = vault_mount.pki_intermediate.path
  certificate = "${vault_pki_secret_backend_root_sign_intermediate.intermediate.certificate}\n${vault_pki_secret_backend_root_sign_intermediate.intermediate.issuing_ca}"
}

resource "vault_pki_secret_backend_role" "backend_role_admin" {
  backend          = vault_mount.pki_intermediate.path
  name             = "admin"
  allowed_domains  = var.allowed_domains
  allow_subdomains = true
  max_ttl          = "28296000"
  key_usage        = ["DigitalSignature", "KeyAgreement", "KeyEncipherment"]
}

resource "vault_pki_secret_backend_role" "backend_role_idam" {
  backend             = vault_mount.pki_intermediate.path
  name                = "${var.namespace}_idam"
  allowed_domains     = var.allowed_domains
  allow_subdomains    = true
  allow_glob_domains  = true
  use_csr_common_name = true
  require_cn          = false
  allow_any_name      = true
}
resource "vault_policy" "cert-policy" {
  name = "cert-policy"

  policy = <<EOT
path "dfq_idam_intermediate/issue*" {
  capabilities = ["create","update"]
}
path "auth/token/renew" {
  capabilities = ["update"]
}
path "auth/token/renew-self" {
  capabilities = ["update"]
}
EOT
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "example" {
  backend        = vault_auth_backend.approle.path
  role_name      = "test-role"
  token_policies = ["cert-policy"]
}

resource "local_file" "roleid" {
  content  = vault_approle_auth_backend_role.example.role_id
  filename = "/vault/agent/certs/role_id"
}

resource "vault_approle_auth_backend_role_secret_id" "id" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.example.role_name
}

resource "local_file" "secretid" {
  content  = vault_approle_auth_backend_role_secret_id.id.secret_id
  filename = "/vault/agent/certs/secret_id"
}
