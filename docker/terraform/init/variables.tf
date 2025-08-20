variable "hostnames" {
  default = {
    "fram" = {
      "tls" : { "namespace" : "dfq", "common_name" : "localhost", "alt_names" : ["localhost", "fram", "*.dfq.localhost", "*.dfq.localdev"] }
    },
    "frim" = {
      "tls" : { "namespace" : "dfq", "common_name" : "localhost", "alt_names" : ["localhost", "frim", "*.dfq.localhost", "*.dfq.localdev"] }
      "selfservice" : { "common_name" : "selfservice" }
    },
    "frig" = {
      "tls" : { "namespace" : "dfq", "common_name" : "localhost", "alt_names" : ["localhost", "frig", "*.dfq.localhost", "*.dfq.localdev"] }
    },
    "frds" = {
      "tls" : { "namespace" : "dfq", "common_name" : "localhost", "alt_names" : ["localhost", "frdsamconfig", "frdsuser", "frdsamcts", "frdsidm", "*.dfq.localhost", "*.dfq.localdev"] }
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
