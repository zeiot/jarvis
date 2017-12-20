# CoreDNS as the Kube DNS

Launch a busybox pod :

```bash
$ kubectl apply -f coredns/busybox.yaml
pod "busybox" created
```

Then check the DNS :

```bash
$ kubectl exec -ti busybox -- nslookup kubernetes.default
Server:    10.96.0.10
Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

Name:      kubernetes.default
Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
Vérifions le DNS utilisé avec l'IP du serveur :

$ kubectl exec busybox cat /etc/resolv.conf
nameserver 10.96.0.10
search default.svc.cluster.local svc.cluster.local cluster.local home
options ndots:5

$ kubectl get svc -n kube-system -l k8s-app=kube-dns
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP   4h
```

Setup CoreDNS :

```bash
$ kubectl apply -f coredns/coredns.yaml
serviceaccount "coredns" created
clusterrole "system:coredns" created
clusterrolebinding "system:coredns" created
configmap "coredns" created
deployment "coredns" created

$ kubectl get pods -n kube-system -l k8s-app=coredns
NAME                       READY     STATUS    RESTARTS   AGE
coredns-56bd994f66-xd7t6   1/1       Running   0          36s
coredns-56bd994f66-z64fq   1/1       Running   0          36s

$ kubectl logs coredns-56bd994f66-xd7t6 -n kube-system -f
.:53
CoreDNS-1.0.1
linux/arm, go1.9.2, 99e163c3
2017/12/20 14:05:57 [INFO] CoreDNS-1.0.1
2017/12/20 14:05:57 [INFO] linux/arm, go1.9.2, 99e163c3
^C

$ kubectl logs coredns-56bd994f66-z64fq -n kube-system -f
.:53
2017/12/20 14:05:59 [INFO] CoreDNS-1.0.1
2017/12/20 14:05:59 [INFO] linux/arm, go1.9.2, 99e163c3
CoreDNS-1.0.1
linux/arm, go1.9.2, 99e163c3
^C
```

Switch to CoreDNS for Service Discovery:

```bash
$ kubectl create -f coredns/coredns-service.yaml
kubectl created
service "kube-dns" configured

$ kubectl describe svc kube-dns -n kube-system
Name:              kube-dns
Namespace:         kube-system
Labels:            k8s-app=coredns
                   kubernetes.io/cluster-service=true
                   kubernetes.io/name=CoreDNS
Annotations:       kubectl.kubernetes.io/last-applied-configuration={"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"k8s-app":"coredns","kubernetes.io/cluster-service":"true","kubernetes.io/na...
Selector:          k8s-app=coredns
Type:              ClusterIP
IP:                10.96.0.10
Port:              dns  53/UDP
TargetPort:        53/UDP
Endpoints:         10.36.0.5:53,10.44.0.2:53
Port:              dns-tcp  53/TCP
TargetPort:        53/TCP
Endpoints:         10.36.0.5:53,10.44.0.2:53
Port:              metrics  9153/TCP
TargetPort:        9153/TCP
Endpoints:         10.36.0.5:9153,10.44.0.2:9153
Session Affinity:  None
Events:            <none>

$ kubectl get po -l k8s-app=coredns -n kube-system -o wide
NAME                       READY     STATUS    RESTARTS   AGE       IP          NODE
coredns-56bd994f66-xd7t6   1/1       Running   0          49m       10.44.0.2   jarvis-node2
coredns-56bd994f66-z64fq   1/1       Running   0          49m       10.36.0.5   jarvis-node1
```

You could switch back to KubeDNS :

```bash
$ kubectl apply -f k8s/coredns/kubedns-service.yaml
```

Try with **google.com** :

```bash
$ dig google.com @10.96.0.10 +short
216.58.198.206
```

```bash
10.32.0.1 - [20/Dec/2017:16:04:13 +0000] "A IN google.com. udp 40 false 4096" NOERROR qr,rd,ra 56 15.033559ms
```

Depends on your choice, you could delete pods :

```bash
$ kubectl delete deployment coredns -n kube-system
```

or

```bash
$ kubectl delete deployment kube-dns -n kube-system
```
