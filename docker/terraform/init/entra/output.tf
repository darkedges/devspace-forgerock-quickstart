output "client_secret" {
  sensitive = true
  value     = tolist(azuread_application.dfq.password).0.value
}
output "client_id" {
  sensitive = false
  value     = azuread_application.dfq.application_id
}
