# Provider flows
data "authentik_flow" "implicit_consent" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "explicit_consent" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "invalidation" {
  slug = "default-provider-invalidation-flow"
}

# Scope mappings for proxy providers (ForwardAuth)
data "authentik_property_mapping_provider_scope" "proxy_scopes" {
  managed_list = [
    "goauthentik.io/providers/proxy/scope-proxy",
    "goauthentik.io/providers/oauth2/scope-profile",
    "goauthentik.io/providers/oauth2/scope-entitlements",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-email",
  ]
}

# Scope mappings for OAuth2/OIDC providers
data "authentik_property_mapping_provider_scope" "oidc_scopes" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-profile",
  ]
}

# Brand flows
data "authentik_flow" "authentication" {
  slug = "default-authentication-flow"
}

data "authentik_flow" "invalidation_brand" {
  slug = "default-invalidation-flow"
}

data "authentik_flow" "user_settings" {
  slug = "default-user-settings-flow"
}

# Signing key for Nextcloud OIDC provider
data "authentik_certificate_key_pair" "self_signed" {
  name = "authentik Self-signed Certificate"
}

# Local Kubernetes service connection (used by embedded outpost)
data "authentik_service_connection_kubernetes" "local" {
  name = "Local Kubernetes Cluster"
}
