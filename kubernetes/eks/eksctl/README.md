# EKS with Eksctl

You must setup your AWS credentials using :

```bash
$ aws configure
```

Then create your cluster :

```bash
$ make eks-eksctl-kubernetes-create SETUP=eksctl
[Jarvis] EKS setup using eksctl
make[1]: Entering directory '/home/nicolas/Projects/Zeiot/jarvis/kubernetes/eks/eksctl'
[Jarvis] Create Kubernetes cluster
[ℹ]  using region eu-west-3
...
[ℹ]  kubectl command should work with "/home/nicolas/.kube/config", try 'kubectl get nodes'
[✔]  EKS cluster "jarvis-prod-eksctl" in "eu-west-3" region is ready

$ kubectl config current-context
iam-root-account@jarvis-prod-eksctl.eu-west-3.eksctl.io

kubectl get pods --all-namespaces
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   aws-node-rbvml             1/1     Running   0          4m11s
kube-system   aws-node-v5rxv             1/1     Running   0          4m11s
kube-system   coredns-746867d898-4dntc   1/1     Running   0          11m
kube-system   coredns-746867d898-9zzxr   1/1     Running   0          11m
kube-system   kube-proxy-d5287           1/1     Running   0          4m11s
kube-system   kube-proxy-p5wnv           1/1     Running   0          4m11s
```
