# Custom scope mapping that exposes Authentik group names as the "groups" claim
# Teleport uses this claim to map users to roles
resource "authentik_property_mapping_provider_scope" "groups" {
  name       = "groups"
  scope_name = "groups"
  expression = "return list(request.user.ak_groups.values_list(\"name\", flat=True))"
}

# OAuth2/OIDC provider for Teleport
resource "authentik_provider_oauth2" "teleport" {
  name               = "Teleport"
  client_id          = var.teleport_oidc_client_id
  client_secret      = var.teleport_oidc_client_secret
  client_type        = "confidential"
  authorization_flow = data.authentik_flow.implicit_consent.id
  invalidation_flow  = data.authentik_flow.invalidation.id
  signing_key        = data.authentik_certificate_key_pair.self_signed.id
  sub_mode           = "hashed_user_id"
  issuer_mode        = "per_provider"
  property_mappings = concat(
    data.authentik_property_mapping_provider_scope.oidc_scopes.ids,
    [authentik_property_mapping_provider_scope.groups.id],
  )

  access_code_validity   = "minutes=1"
  access_token_validity  = "minutes=5"
  refresh_token_validity = "days=30"

  allowed_redirect_uris = [
    {
      matching_mode = "strict"
      url           = "https://teleport.trashstack.dev/v1/webapi/oidc/callback"
    }
  ]
}

resource "authentik_application" "teleport" {
  name              = "Teleport"
  slug              = "teleport"
  protocol_provider = authentik_provider_oauth2.teleport.id
}
