resource "random_uuid" "app_access_scope_id" {}
resource "random_uuid" "provider_read_scope_id" {}
resource "random_uuid" "provider_write_scope_id" {}
resource "random_uuid" "app_role_id" {}
resource "time_rotating" "example" {
  rotation_days = 180
}
resource "azuread_application" "dfq" {
  display_name = var.applicationDisplayName
  logo_image   = filebase64("logo.jpg")
  owners = [
    data.azuread_client_config.current.object_id
  ]
  identifier_uris = var.applicationIdentifierUris

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 1

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ${var.applicationDisplayName} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${var.applicationDisplayName}"
      enabled                    = true
      id                         = random_uuid.app_access_scope_id.result
      type                       = "User"
      user_consent_description   = "Allow the application to access ${var.applicationDisplayName} on your behalf."
      user_consent_display_name  = "Access ${var.applicationDisplayName}"
      value                      = "user_impersonation"
    }

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to Read Provider Details"
      admin_consent_display_name = "Read Provider Details"
      user_consent_description   = "Allow the application to Read Provider Details"
      user_consent_display_name  = "Read Provider Details"
      enabled                    = true
      id                         = random_uuid.provider_read_scope_id.result
      type                       = "User"
      value                      = "provider.read"
    }

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to Write Provider Details"
      admin_consent_display_name = "Write Provider Details"
      user_consent_description   = "Allow the application to Write Provider Details"
      user_consent_display_name  = "Write Provider Details"
      enabled                    = true
      id                         = random_uuid.provider_write_scope_id.result
      type                       = "User"
      value                      = "provider.write"
    }
  }

  app_role {
    id = random_uuid.app_role_id.result
    allowed_member_types = [
      "Application",
      "User"
    ]
    description  = "Task.write"
    display_name = "Task.write"
    enabled      = true
    value        = "Task.write"
  }

  feature_tags {
    enterprise = true
    gallery    = true
  }

  single_page_application {
    redirect_uris = var.applicationSPARedirectUris
  }

  web {
    redirect_uris = var.applicationwebRedirectUris
    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["email"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["offline_access"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["openid"]
      type = "Scope"
    }
    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["profile"]
      type = "Scope"
    }
  }
  optional_claims {
    id_token {
      name      = "email"
      source    = "user"
      essential = true
    }
    id_token {
      name      = "family_name"
      source    = "user"
      essential = true
    }
    id_token {
      name      = "given_name"
      source    = "user"
      essential = true
    }
  }
  password {
    display_name = "MySecret-1"
    start_date   = time_rotating.example.id
    end_date     = timeadd(time_rotating.example.id, "4320h")
  }
}

resource "azuread_service_principal" "dfq" {
  client_id = azuread_application.dfq.application_id
  owners    = azuread_application.dfq.owners
  feature_tags {
    enterprise = true
    gallery    = true
  }
}

resource "azuread_application_pre_authorized" "dfq" {
  application_id       = azuread_application.dfq.id
  authorized_client_id = azuread_application.dfq.client_id
  permission_ids = [
    random_uuid.app_access_scope_id.result,
    random_uuid.provider_read_scope_id.result,
    random_uuid.provider_write_scope_id.result,
  ]
}
