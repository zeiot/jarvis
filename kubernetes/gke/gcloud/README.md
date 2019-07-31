# GKE with Gcloud SDK

You must authenticat to GCloud :

```bash
$ gcloud auth login
```

Then create your cluster :

```bash


$ make gke-gcloud-kubernetes-create SETUP=gcloud

$ kubectl config current-context
gke_jarvis-prod-1_europe-west1-c_jarvis-prod-gcloud


$ kubectl get nodes
NAME                                                STATUS   ROLES    AGE    VERSION
gke-jarvis-prod-gcloud-default-pool-0911187b-7ccz   Ready    <none>   102m   v1.12.8-gke.10
gke-jarvis-prod-gcloud-default-pool-0911187b-8pxx   Ready    <none>   102m   v1.12.8-gke.10
gke-jarvis-prod-gcloud-default-pool-0911187b-fp2c   Ready    <none>   102m   v1.12.8-gke.10
```

To setup Kubernetes manifests you must set the `KUBE_CONTEXT` variable :

```bash
$ make gke-gcloud-kube-context SETUP=gcloud
[Jarvis] GKE setup using gcloud
gke_jarvis-prod-1_europe-west1-c_jarvis-prod-gcloud
$ export KUBE_CONTEXT="gke_jarvis-prod-1_europe-west1-c_jarvis-prod-gcloud"
```

When you want to delete it :

```bash
$ make gke-gcloud-kubernetes-delete SETUP=gcloud

```