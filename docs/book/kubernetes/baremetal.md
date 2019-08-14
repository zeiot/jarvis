# Bare Metal

## CNI

Several [Container Network Interface - CNI](https://github.com/containernetworking) providers are available :

* ![Flannel](flannel.png) [Flannel](https://github.com/coreos/flannel)
* ![Calico](calico.png) [Calico](https://www.projectcalico.org/)
* ![WeaveNet](weavenet.png) [WeaveNet](https://www.weave.works/oss/net/)

Choose one and install it :

```bash
$ make kubernetes-apply SERVICE=kube-system/xxxxx ENV=homelab
```

## MetalLB

![metallb](metallb.png)

We use [metallb](https://metallb.universe.tf/) in the bare metal setup.

```bash
$ make kubernetes-apply SERVICE=metallb-system/metallb ENV=homelab
```

## NFS client provisioner

We use a NFS server for storage. We install an automatic provisioner that use our already configured NFS server to support dynamic provisioning of Kubernetes Persistent Volumes via Persistent Volume Claims.

```bash
$ make kubernetes-apply SERVICE=storage/nfs-client-provisioner ENV=homelab
```