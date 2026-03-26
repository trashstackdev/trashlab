# Trashlab

My GitOps configuration for a single-node k3s cluster on a Hetzner EX44, managed by [Flux Operator](https://fluxoperator.dev).

## Services

| Service | URL |
|---|---|
| Authentik | https://auth.trashstack.dev |
| Flux UI | https://flux.trashstack.dev |
| Traefik Dashboard | https://traefik.trashstack.dev |
| Nextcloud | https://cloud.trashstack.dev |
| Bluemap | https://bluemap.trashstack.dev |

## Stack

| Component | Purpose |
|---|---|
| k3s | Kubernetes distribution |
| Flux Operator | GitOps via `FluxInstance` |
| Traefik | Ingress, TLS termination |
| cert-manager | TLS via Let's Encrypt |
| Longhorn | Persistent block storage |
| External Secrets | Secrets from Bitwarden SM |
| Authentik | SSO / ForwardAuth |

## Structure

```
clusters/trashlab/   # Flux entry point
infrastructure/
  controllers/       # Helm releases for cluster components
  configs/           # Post-install config (secrets, notifications)
apps/                # Workloads
```
