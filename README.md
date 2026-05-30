# trashlab

Personal k3s homelab on a Hetzner EX44, managed with Flux Operator.

[![Flux Local](https://github.com/trashstackdev/trashlab/actions/workflows/flux-local.yaml/badge.svg)](https://github.com/trashstackdev/trashlab/actions/workflows/flux-local.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Apps

| App | Description | URL |
|---|---|---|
| Nextcloud | Self-hosted file sync and storage | https://cloud.trashstack.dev |
| Authentik | Identity provider and SSO | https://auth.trashstack.dev |
| Bluemap | Live Minecraft world map | https://bluemap.trashstack.dev |
| Longhorn | Storage dashboard | https://longhorn.trashstack.dev |
| Flux UI | GitOps dashboard | https://flux.trashstack.dev |
| Traefik | Ingress dashboard | https://traefik.trashstack.dev |

There's also a private [Sure](https://github.com/we-promise/sure) deployment, a Rails personal finance app with its own Helm chart in `charts/sure/`.

## Stack

| Component | Purpose |
|---|---|
| [k3s](https://k3s.io) | Kubernetes distribution |
| [Flux Operator](https://fluxoperator.dev) | GitOps via `FluxInstance` |
| [Traefik](https://traefik.io) | Ingress, HTTPS only |
| [cert-manager](https://cert-manager.io) | TLS via Let's Encrypt |
| [Longhorn](https://longhorn.io) | Persistent block storage |
| [CloudNativePG](https://cloudnative-pg.io) | Managed PostgreSQL |
| [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts) | Metrics and alerting |
| [External Secrets](https://external-secrets.io) | Secret sync from Bitwarden SM |
| [Authentik](https://goauthentik.io) | SSO and ForwardAuth |

## Structure

```
clusters/trashlab/      # Flux entry point, kustomizations
infrastructure/
  controllers/          # Helm releases for cluster components
  configs/              # Post-install config (secrets, notifications)
apps/                   # Workloads
charts/                 # Custom Helm charts
```

Flux reconciles in dependency order: controllers → configs → apps. HelmReleases poll every hour; everything else every minute.

## Secrets

Nothing sensitive is committed in plaintext. [External Secrets Operator](https://external-secrets.io) pulls secrets from Bitwarden Secrets Manager at runtime. Anything that does need to live in the repo (org IDs, store config) is encrypted with [SOPS](https://github.com/getsops/sops) + age before committing.

## Automation

[Renovate](https://docs.renovatebot.com) opens PRs for dependency bumps. Non-major updates are grouped into a single PR; major chart versions require manual approval. Every PR is validated by [flux-local](https://github.com/allenporter/flux-local), which fully renders the Kustomize tree and all HelmRelease charts before anything merges.

Flux reconciliation events are forwarded to Discord and posted back as GitHub commit statuses.

---

[Claude Code](https://claude.ai/code) was used for most of the tedious parts. (Like writing markdowns.)