variable "applicationDisplayName" {
  type    = string
  default = "DFQ Local Development"
}

variable "applicationIdentifierUris" {
  type = list(string)
  default = [
    "https://example.com/openam/oauth2"
  ]
}

variable "applicationSPARedirectUris" {
  type = list(string)
  default = [
    "http://localhost:4200/"
  ]
}

variable "applicationwebRedirectUris" {
  type = list(string)
  default = [
    "https://example.com/openam/XUI"
  ]
}
