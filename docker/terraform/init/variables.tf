variable "hostnames" {
  default = {
    "fram" = {
      "tls" : { "namespace" : "darkedges", "common_name" : "localhost", "alt_names" : ["localhost", "fram", "*.darkedges.localhost", "*.darkedges.localdev"] }
    },
    "frim" = {
      "tls" : { "namespace" : "darkedges", "common_name" : "localhost", "alt_names" : ["localhost", "frim", "*.darkedges.localhost", "*.darkedges.localdev"] }
      "selfservice" : { "common_name" : "selfservice" }
    },
    "frig" = {
      "tls" : { "namespace" : "darkedges", "common_name" : "localhost", "alt_names" : ["localhost", "frig", "*.darkedges.localhost", "*.darkedges.localdev"] }
    },
    "frds" = {
      "tls" : { "namespace" : "darkedges", "common_name" : "localhost", "alt_names" : ["localhost", "frdsamconfig", "frdsuser", "frdsamcts", "frdsidm", "*.darkedges.localhost", "*.darkedges.localdev"] }
    }
  }
}

locals {
  helper_list = flatten([for service, value in var.hostnames :
    flatten([for certificate, config in value :
      {
        "service"     = service,
        "certificate" = certificate,
        "config"      = config
      }
    ])
  ])
}
