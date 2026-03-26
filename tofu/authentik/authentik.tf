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
resource "authentik_group" "admins" {
  name         = "authentik Admins"
  is_superuser = true
}

# Applications
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
