# Brand
resource "authentik_brand" "default" {
  domain                 = "authentik-default"
  default                = true
  branding_title         = "TrashStack.dev - Authentik"
  branding_logo          = "/static/dist/assets/icons/icon_left_brand.svg"
  branding_favicon       = "/static/dist/assets/icons/icon.png"
  flow_authentication    = data.authentik_flow.authentication.id
  flow_invalidation      = data.authentik_flow.invalidation_brand.id
  flow_user_settings     = data.authentik_flow.user_settings.id
}

# Groups
# Membership is managed here, so a user added by hand in the UI is removed on the next apply.
# Usernames come from tfvars to keep the admin accounts out of this public repo.
data "authentik_user" "admins" {
  for_each = toset(var.admin_usernames)
  username = each.value
}

resource "authentik_group" "admins" {
  name         = "authentik Admins"
  is_superuser = true
  users        = [for u in data.authentik_user.admins : u.pk]
}

# Guests who use Immich and nothing else. Members are added by hand in the UI, not here.
resource "authentik_group" "immich_users" {
  name = "immich-users"
}

# Applications
# Every application needs an entry in local.admin_apps below: without a binding, any Authentik user can open it.
resource "authentik_application" "flux_ui" {
  name              = "Flux UI"
  slug              = "flux-ui"
  protocol_provider = authentik_provider_proxy.flux_ui.id
  meta_icon         = "https://raw.githubusercontent.com/cncf/artwork/3e09078b447395d14093989e8718bf3b115b5101/projects/flux/icon/color/flux-icon-color.svg"
}

resource "authentik_application" "longhorn_ui" {
  name              = "Longhorn UI"
  slug              = "longhorn-ui"
  protocol_provider = authentik_provider_proxy.longhorn_ui.id
  meta_icon         = "https://raw.githubusercontent.com/cncf/artwork/3e09078b447395d14093989e8718bf3b115b5101/projects/longhorn/icon/color/longhorn-icon-color.svg"
}

resource "authentik_application" "traefik_dashboard" {
  name              = "Traefik Dashboard"
  slug              = "traefik-dashboard"
  protocol_provider = authentik_provider_proxy.traefik_dashboard.id
}

resource "authentik_application" "grafana" {
  name              = "Grafana"
  slug              = "grafana"
  protocol_provider = authentik_provider_oauth2.grafana.id
  meta_icon         = "https://raw.githubusercontent.com/grafana/grafana/main/public/img/grafana_icon.svg"
}

resource "authentik_application" "sure" {
  name              = "Sure Finance"
  slug              = "sure"
  protocol_provider = authentik_provider_oauth2.sure.id
}

resource "authentik_application" "nextcloud" {
  name              = "Nextcloud"
  slug              = "nextcloud"
  protocol_provider = authentik_provider_oauth2.nextcloud.id
  meta_icon         = "https://nextcloud.com/c/uploads/2025/10/Nextcloud_02-blue-logo.svg"
}

resource "authentik_application" "immich" {
  name              = "Immich"
  slug              = "immich"
  protocol_provider = authentik_provider_oauth2.immich.id
  meta_icon         = "https://raw.githubusercontent.com/immich-app/immich/v3.3.3/design/immich-logo.svg"
}

resource "authentik_application" "dawarich" {
  name              = "Dawarich"
  slug              = "dawarich"
  protocol_provider = authentik_provider_oauth2.dawarich.id
  meta_icon         = "https://raw.githubusercontent.com/Freika/dawarich/1.16.0/public/icon.svg"
}

resource "authentik_application" "forgejo" {
  name              = "Forgejo"
  slug              = "forgejo"
  protocol_provider = authentik_provider_oauth2.forgejo.id
  meta_icon         = "https://code.forgejo.org/forgejo/forgejo/raw/branch/forgejo/assets/logo.svg"
}

resource "authentik_outpost" "embedded" {
  name               = "authentik Embedded Outpost"
  type               = "proxy"
  service_connection = data.authentik_service_connection_kubernetes.local.id
  protocol_providers = [
    authentik_provider_proxy.flux_ui.id,
    authentik_provider_proxy.longhorn_ui.id,
    authentik_provider_proxy.traefik_dashboard.id,
  ]
  config = jsonencode({
    authentik_host       = var.authentik_url
    kubernetes_namespace = "authentik"
    kubernetes_replicas  = 1
    log_level            = "info"
  })
}

# Access bindings
# Group bindings need no policy object. An application with at least one binding admits only matching users.
locals {
  admin_apps = {
    flux_ui           = authentik_application.flux_ui.uuid
    longhorn_ui       = authentik_application.longhorn_ui.uuid
    traefik_dashboard = authentik_application.traefik_dashboard.uuid
    grafana           = authentik_application.grafana.uuid
    sure              = authentik_application.sure.uuid
    nextcloud         = authentik_application.nextcloud.uuid
    immich            = authentik_application.immich.uuid
    dawarich          = authentik_application.dawarich.uuid
    forgejo           = authentik_application.forgejo.uuid
  }
}

resource "authentik_policy_binding" "admins" {
  for_each = local.admin_apps
  target   = each.value
  group    = authentik_group.admins.id
  order    = 0
}

resource "authentik_policy_binding" "immich_users" {
  target = authentik_application.immich.uuid
  group  = authentik_group.immich_users.id
  order  = 10
}
