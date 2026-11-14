terraform {
  required_version = ">= 1.8.0"

  # The state lives in the cluster, as a Secret in kube-system with a Lease as lock, so every machine with
  # admin access to the cluster works on the same state and two runs can't overlap. It holds client secrets,
  # which the cluster holds anyway. It is gone when the cluster is rebuilt: run `tofu state pull` into a file
  # before, and `tofu state push` it after.
  backend "kubernetes" {
    secret_suffix = "authentik"
    namespace     = "kube-system"
    config_path   = "~/.kube/config"
  }
  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "~> 2026.0"
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

# Usernames that belong to the superuser group "authentik Admins"
variable "admin_usernames" {
  type = list(string)

  validation {
    condition     = length(var.admin_usernames) > 0
    error_message = "List at least one admin, or the apply locks everyone out."
  }
}

variable "nextcloud_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "nextcloud_oidc_client_id" {
  type = string
}

variable "grafana_oidc_client_id" {
  type = string
}

variable "grafana_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "immich_oidc_client_id" {
  type = string
}

variable "immich_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "dawarich_oidc_client_id" {
  type = string
}

variable "dawarich_oidc_client_secret" {
  type      = string
  sensitive = true
}

variable "forgejo_oidc_client_id" {
  type = string
}

variable "forgejo_oidc_client_secret" {
  type      = string
  sensitive = true
}
