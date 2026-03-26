# ForwardAuth proxy provider for Flux UI
resource "authentik_provider_proxy" "flux_ui" {
  name                  = "flux-ui"
  external_host         = "https://flux.trashstack.dev"
  mode                  = "forward_single"
  authorization_flow    = data.authentik_flow.implicit_consent.id
  invalidation_flow     = data.authentik_flow.invalidation.id
  property_mappings     = data.authentik_property_mapping_provider_scope.proxy_scopes.ids
  access_token_validity = "hours=24"
}

# ForwardAuth proxy provider for Longhorn UI
resource "authentik_provider_proxy" "longhorn_ui" {
  name                  = "longhorn-ui"
  external_host         = "https://longhorn.trashstack.dev/"
  mode                  = "forward_single"
  authorization_flow    = data.authentik_flow.implicit_consent.id
  invalidation_flow     = data.authentik_flow.invalidation.id
  property_mappings     = data.authentik_property_mapping_provider_scope.proxy_scopes.ids
  access_token_validity = "hours=24"
}

# ForwardAuth proxy provider for Traefik Dashboard
resource "authentik_provider_proxy" "traefik_dashboard" {
  name                  = "traefik-dashboard"
  external_host         = "https://traefik.trashstack.dev"
  mode                  = "forward_single"
  authorization_flow    = data.authentik_flow.implicit_consent.id
  invalidation_flow     = data.authentik_flow.invalidation.id
  property_mappings     = data.authentik_property_mapping_provider_scope.proxy_scopes.ids
  access_token_validity = "hours=24"
}

# OAuth2/OIDC provider for Sure Finance
resource "authentik_provider_oauth2" "sure" {
  name          = "Sure Finance"
  client_id     = var.sure_oidc_client_id
  client_secret = var.sure_oidc_client_secret
  client_type   = "confidential"
  authorization_flow = data.authentik_flow.implicit_consent.id
  invalidation_flow  = data.authentik_flow.invalidation.id
  signing_key        = data.authentik_certificate_key_pair.self_signed.id
  sub_mode           = "hashed_user_id"
  issuer_mode        = "per_provider"
  property_mappings  = data.authentik_property_mapping_provider_scope.oidc_scopes.ids

  access_code_validity   = "minutes=1"
  access_token_validity  = "minutes=5"
  refresh_token_validity = "days=30"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://sure.trashstack.dev/auth/openid_connect/callback"
    }
  ]
}

# OAuth2/OIDC provider for Grafana
resource "authentik_provider_oauth2" "grafana" {
  name               = "Grafana"
  client_id          = var.grafana_oidc_client_id
  client_secret      = var.grafana_oidc_client_secret
  client_type        = "confidential"
  authorization_flow = data.authentik_flow.implicit_consent.id
  invalidation_flow  = data.authentik_flow.invalidation.id
  signing_key        = data.authentik_certificate_key_pair.self_signed.id
  sub_mode           = "hashed_user_id"
  issuer_mode        = "per_provider"
  property_mappings  = data.authentik_property_mapping_provider_scope.oidc_scopes_with_offline.ids

  access_code_validity   = "minutes=1"
  access_token_validity  = "minutes=5"
  refresh_token_validity = "days=30"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://grafana.trashstack.dev/login/generic_oauth"
    }
  ]
}

# OAuth2/OIDC provider for Nextcloud
resource "authentik_provider_oauth2" "nextcloud" {
  name               = "Nextcloud"
  client_id          = var.nextcloud_oidc_client_id
  client_secret      = var.nextcloud_oidc_client_secret
  client_type        = "confidential"
  authorization_flow = data.authentik_flow.explicit_consent.id
  invalidation_flow  = data.authentik_flow.invalidation.id
  signing_key        = data.authentik_certificate_key_pair.self_signed.id
  sub_mode           = "hashed_user_id"
  issuer_mode        = "per_provider"
  property_mappings  = data.authentik_property_mapping_provider_scope.oidc_scopes.ids

  access_code_validity       = "minutes=1"
  access_token_validity      = "minutes=5"
  refresh_token_validity     = "days=30"
  refresh_token_threshold    = "hours=1"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://cloud.trashstack.dev/apps/user_oidc/code"
    }
  ]
}
