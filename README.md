# Trashlab

My GitOps configuration for a single-node k3s cluster on a Hetzner EX44, managed by [Flux Operator](https://fluxoperator.dev).

## Stack
- **k3s** — my Kubernetes distribution of choice
- **Flux Operator** — manages Flux itself via `FluxInstance`
- **Traefik** — ingress controller (maybe caddy later)
- **Longhorn** — persistent block storage
- **cert-manager** — for TLS via Let's Encrypt

## Structure

```
clusters/
└── trashlab/               # entry point watched by Flux
    ├── flux-instance.yaml  # FluxInstance — manages Flux controllers
    └── infrastructure.yaml # points to infrastructure/

infrastructure/
└── controllers/
    ├── flux-operator/
    ├── traefik/
    └── longhorn/
```

Flux watches `clusters/trashlab/` on `main` and reconciles any change automatically.
