# readonly-agent

Agent-agnostic read-only Kubernetes access for AI agents and automation running on the server
under their own unprivileged Linux user. For another agent, add its own ServiceAccount and token Secret and bind
them to the same roles (`view`, `readonly-extra`, `readonly-monitoring-proxy`).
It can read workloads, logs, CRDs and cluster objects, but not Secrets, and it cannot
exec into pods, port-forward or change anything. Changes still go through Git and Flux.

## Build the kubeconfig (run from a machine with admin access)

```sh
ns=kube-system; s=readonly-agent-token
token=$(kubectl -n $ns get secret $s -o jsonpath='{.data.token}' | base64 -d)
ca=$(kubectl -n $ns get secret $s -o jsonpath='{.data.ca\.crt}')
# Pipe the result to the agent user's ~/.kube/config on the server (mode 600)
cat << CFG
apiVersion: v1
kind: Config
clusters:
  - name: trashlab
    cluster:
      server: https://127.0.0.1:6443
      certificate-authority-data: $ca
users:
  - name: readonly-agent
    user:
      token: $token
contexts:
  - name: trashlab
    context: {cluster: trashlab, user: readonly-agent}
current-context: trashlab
CFG
```

On the server, set `KUBECONFIG=~/.kube/config` for that user, because k3s's kubectl otherwise tries
the root-only `/etc/rancher/k3s/k3s.yaml`.

## Revoke

Delete the `readonly-agent-token` Secret (Kubernetes invalidates the token), or remove this
folder from `infrastructure/configs/kustomization.yaml`.
