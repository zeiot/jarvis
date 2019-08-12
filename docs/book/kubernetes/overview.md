# Overview

![Kustomize](kustomize.png)

For the management of Kubernetes resources, [kustomize](https://kustomize.io/) is used.

For each components we specify overlays :

* `homelab` is the bare metal ARM cluster
* `prod`, `staging` , ... are the others

Creates the namespaces :

```bash
$ make kubernetes-apply SERVICE=namespaces ENV=xxxx
```
