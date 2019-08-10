# AKS with Azure CLI

## Description

Then create your cluster :

```bash
$ make aks-cli-kubernetes-create
```

THen configure credentials for `kubectl` :

```bash
$ make aks-cli-kubernetes-credentials SETUP=cli
```

When you want to delete it :

```bash
$ make aks-cli-kubernetes-delete SETUP=cli
```