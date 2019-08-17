# Jarvis on ARM devices with k3s

## Description

A Kubernetes cluster using `docker compose`

## Setup

Check dependencies and install dependencies :

```bash
$ make local-k3d-deps SETUP=k3d
$ mv k3d /usr/local/bin/
$ make local-k3d-check SETUP=k3d
[Jarvis] Local setup using k3d
[✅] k3d
```

Create the cluser :

```bash
$ make local-k3d-create SETUP=k3d
```

and configure `kubectl` :

```bash
$ make local-k3d-config SETUP=k3d
[Jarvis] Local setup using k3d
/home/nicolas/.config/k3d/jarvis/kubeconfig.yaml

$ export KUBECONFIG="/home/nicolas/.config/k3d/jarvis/kubeconfig.yaml"

$ kubectl config get-contexts
CURRENT   NAME      CLUSTER   AUTHINFO   NAMESPACE
*         default   default   default

$ kubectl cluster-info
Kubernetes master is running at https://localhost:6443
CoreDNS is running at https://localhost:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
