terraform {
  required_version = "~> 1.6.3"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.22.0"
    }
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
  backend "local" { path = "/mnt/terraform/state" }
}
