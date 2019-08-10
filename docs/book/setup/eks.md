# Jarvis on Amazon Elastic Kubernetes Service

## Description

We will use [eksctl](https://eksctl.io) tool.

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

And delete it :

```bash
$ make eks-eksctl-kubernetes-delete SETUP=eksctl
[Jarvis] EKS setup using eksctl
make[1]: Entering directory '/home/nicolas/Projects/Zeiot/jarvis/kubernetes/eks/eksctl'
[Jarvis] delete Kubernetes cluster
[ℹ]  using region eu-west-3
[ℹ]  deleting EKS cluster "jarvis-prod-eksctl"
[✔]  kubeconfig has been updated
[ℹ]  cleaning up LoadBalancer services
[ℹ]  2 sequential tasks: { delete nodegroup "ng-1", delete cluster control plane "jarvis-prod-eksctl" [async] }
[ℹ]  will delete stack "eksctl-jarvis-prod-eksctl-nodegroup-ng-1"
[ℹ]  waiting for stack "eksctl-jarvis-prod-eksctl-nodegroup-ng-1" to get deleted
[ℹ]  will delete stack "eksctl-jarvis-prod-eksctl-cluster"
[✔]  all cluster resources were deleted
make[1]: Leaving directory '/home/nicolas/Projects/Zeiot/jarvis/kubernetes/eks/eksctl'
```