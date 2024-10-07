variable "application_display_name" {
  type    = string
  default = "DFQ Local Development"
}

variable "application_identifier_uris" {
  type = list(string)
  default = [
    "https://example.com/openam/oauth2"
  ]
}

variable "application_spa_redirect_uris" {
  type = list(string)
  default = [
    "http://localhost:4200/"
  ]
}

variable "application_web_redirect_uris" {
  type = list(string)
  default = [
    "https://example.com/openam/XUI"
  ]
}

variable "application_required_resource_access" {
  description = "Required resource access for this application."
  type = list(
    object({
      resource_app_id = string
      resource_access = list(
        object({
          id   = string
          type = string
      }))
  }))
  default = [
    {
      resource_app_id = "MicrosoftGraph"
      resource_access = [
        {
          id   = "User.Read",
          type = "Scope"
        }
      ]
    }
  ]
}
