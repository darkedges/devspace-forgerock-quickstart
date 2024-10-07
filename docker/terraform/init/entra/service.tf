resource "random_uuid" "app_access_scope_id" {}
resource "random_uuid" "provider_read_scope_id" {}
resource "random_uuid" "provider_write_scope_id" {}
resource "random_uuid" "app_role_id" {}
resource "time_rotating" "example" {
  rotation_days = 180
}
resource "azuread_application" "dfq" {
  display_name = var.application_display_name
  logo_image   = filebase64("logo.jpg")
  owners = [
    data.azuread_client_config.current.object_id
  ]
  identifier_uris  = var.application_identifier_uris
  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  api {
    mapped_claims_enabled          = true
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allow the application to access ${var.application_display_name} on behalf of the signed-in user."
      admin_consent_display_name = "Access ${var.application_display_name}"
      enabled                    = true
      id                         = random_uuid.app_access_scope_id.result
      type                       = "User"
      user_consent_description   = "Allow the application to access ${var.application_display_name} on your behalf."
      user_consent_display_name  = "Access ${var.application_display_name}"
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
    redirect_uris = var.application_spa_redirect_uris
  }

  web {
    redirect_uris = var.application_web_redirect_uris
    implicit_grant {
      access_token_issuance_enabled = true
      id_token_issuance_enabled     = true
    }
  }

  dynamic "required_resource_access" {
    for_each = var.application_required_resource_access
    iterator = resource
    content {
      resource_app_id = data.azuread_application_published_app_ids.well_known.result[resource.value.resource_app_id]

      dynamic "resource_access" {
        for_each = resource.value.resource_access
        iterator = access
        content {
          id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids[access.value.id]
          type = access.value.type
        }
      }
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
  client_id = azuread_application.dfq.client_id
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
