# Homelab environment with k3d

Install dependencies :

```bash
$ make homelab-k3d-deps
$ mv k3d /usr/local/bin
$ make homelab-k3d-check
make homelab-k3d-check
[✅] k3d
```

Then create the cluster :

```bash
$ make homelab-k3d-create
```

You could access it using `kubectl`:

```bash
$ export KUBECONFIG=$(make homelab-k3d-config)
$ kubectl get nodes
NAME                  STATUS   ROLES    AGE    VERSION
k3d-jarvis-server     Ready    master   2m1s   v1.14.4-k3s.1
k3d-jarvis-worker-0   Ready    worker   2m7s   v1.14.4-k3s.1
k3d-jarvis-worker-1   Ready    worker   2m7s   v1.14.4-k3s.1
```

And delete it :

```bash
$ make homelab-k3d-delete
```
