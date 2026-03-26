terraform {
  required_version = ">= 1.8.0"
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2025.12"
    }
  }
}

provider "authentik" {
  url   = var.authentik_url
  token = var.authentik_token
}

variable "authentik_url" {
  type    = string
  default = "https://auth.trashstack.dev"
}

variable "authentik_token" {
  type      = string
  sensitive = true
}

variable "nextcloud_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "nextcloud_oidc_client_id" {
  type = string
}

variable "sure_oidc_client_id" {
  type = string
}

variable "sure_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "grafana_oidc_client_id" {
  type = string
}

variable "grafana_oidc_client_secret" {
  type      = string
  sensitive = true
}

