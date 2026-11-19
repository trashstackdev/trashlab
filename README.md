# Trashlab

GitOps configuration for a single-node k3s cluster on a Hetzner EX44, managed by [Flux Operator](https://fluxoperator.dev).

**This is a snapshot of a private repository**, refreshed by hand now and then (this one: `e245afb`, 2026-11-19). Some parts are left out: private apps, SOPS-encrypted configuration and the rules that detect attacks. Secret IDs, storage addresses and the server's IP are replaced with placeholders. It shows how the cluster is built; it isn't meant to be deployed as is.

## How it runs

- **Git:** the private source lives on a self-hosted Forgejo inside this cluster, with a push mirror to GitLab as the way back when Forgejo itself is gone.
- **Flux** reads it over the cluster-internal Service. A push webhook triggers each fetch, and the layers (controllers, configs, apps) wait 5 s for each other.
- **CI** runs on a self-hosted Forgejo Actions runner: one unprivileged pod (Pod Security restricted) running in the flux-local image, with `flux-local test` and `gitleaks` over the whole history. Both are required checks on `main`.
- **Renovate** runs self-hosted as a CronJob against Forgejo; Immich, Dawarich and Photon wait 3 days for each release.
- **Secrets** come from Bitwarden Secrets Manager through External Secrets. Every namespace denies ingress by default.

## Services

| Service | Purpose |
|---|---|
| Authentik | SSO, OIDC and ForwardAuth, configured with OpenTofu (`tofu/authentik/`) |
| Nextcloud | Files |
| Immich | Photos |
| Dawarich | Location history, with a self-hosted Photon for geocoding |
| Forgejo | Git, CI |
| BlueMap | Map of a game server |

## Stack

| Component | Purpose |
|---|---|
| k3s | Kubernetes distribution |
| Flux Operator | GitOps via `FluxInstance` |
| Traefik | Ingress, TLS termination |
| cert-manager | TLS via Let's Encrypt |
| Longhorn | Persistent block storage, backups to a Storage Box |
| CloudNativePG | Postgres |
| External Secrets | Secrets from Bitwarden SM |
| Reloader | Restarts opted-in workloads when a Secret they read at startup changes |
| kube-prometheus-stack | Metrics and alerts, Grafana |
| VictoriaLogs and Vector | Pod logs and the host journal |
| k8up | Offsite backups to Backblaze B2 |

## Structure

```
clusters/trashlab/   # Flux entry point: FluxInstance and the layers
infrastructure/
  controllers/       # Helm releases for cluster components
  configs/           # Post-install config (secrets, policies, notifications)
apps/                # Workloads
tofu/authentik/      # Authentik as code
.forgejo/workflows/  # CI
```
