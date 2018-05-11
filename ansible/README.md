# Kubernetes installation with Ansible

Ansible is used to setup *Kubernetes*.

Runtime:

* [x] Docker
* [ ] cri-containerd
* [ ] cri-o

Prerequisite:

* unique MAC address
* unique machine_id

Use *debug.yml* to verify that.

## Install

Edit the **inventory** file :

```bash
[master]
<master_ip_address>         ansible_connection=ssh        ansible_user=pirate

[nodes]
<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate
```

Test :

    $ ansible all -m ping -i inventory

## Usage

### Debug Kubernetes hosts informations

    $ ansible-playbook -i inventory debug.yml

### Initialize hosts

    $ ansible-playbook -i inventory bootstrap.yml

### Update distribution

	$ ansible-playbook -i inventory update.yml

### Setup

	$ ansible-playbook -i inventory site.yml

    PLAY [Kubernetes setup] ******************************************************************

    TASK [master : Cluster token] ************************************************************
    ok: [192.168.1.36]

    TASK [master : debug] ********************************************************************
    ok: [192.168.1.36] => {
        "msg": "Kubernetes token: 14b539.de95fe444fb68be1"
    }

    TASK [master : Initialize cluster] *******************************************************
    changed: [192.168.1.36]

    TASK [master : debug] ********************************************************************
    ok: [192.168.1.36] => {
        "msg": "Kubernetes init: [kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.\n[init] Using Kubernetes version: v1.8.5\n[init] Using Authorization modes: [Node RBAC]\n[prefligh
    t] Skipping pre-flight checks\n[kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)\n[certificates] Generated ca certificate and key.
    \n[certificates] Generated apiserver certificate and key.\n[certificates] apiserver serving cert is signed for DNS names [jarvis-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.
    cluster.local] and IPs [10.96.0.1 192.168.1.36]\n[certificates] Generated apiserver-kubelet-client certificate and key.\n[certificates] Generated sa key and public key.\n[certificates] Generated front-proxy-ca ce
    rtificate and key.\n[certificates] Generated front-proxy-client certificate and key.\n[certificates] Valid certificates and keys now exist in \"/etc/kubernetes/pki\"\n[kubeconfig] Wrote KubeConfig file to disk: \
    "admin.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"kubelet.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"controller-manager.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"scheduler.conf\"
    \n[controlplane] Wrote Static Pod manifest for component kube-apiserver to \"/etc/kubernetes/manifests/kube-apiserver.yaml\"\n[controlplane] Wrote Static Pod manifest for component kube-controller-manager to \"/e
    tc/kubernetes/manifests/kube-controller-manager.yaml\"\n[controlplane] Wrote Static Pod manifest for component kube-scheduler to \"/etc/kubernetes/manifests/kube-scheduler.yaml\"\n[etcd] Wrote Static Pod manifest
for a local etcd instance to \"/etc/kubernetes/manifests/etcd.yaml\"\n[init] Waiting for the kubelet to boot up the control plane as Static Pods from directory \"/etc/kubernetes/manifests\"\n[init] This often ta
    kes around a minute; or longer if the control plane images have to be pulled.\n[apiclient] All control plane components are healthy after 68.015205 seconds\n[uploadconfig] Storing the configuration used in Config
    Map \"kubeadm-config\" in the \"kube-system\" Namespace\n[markmaster] Will mark node jarvis-master as master by adding a label and a taint\n[markmaster] Master jarvis-master tainted and labelled with key/value: n
    ode-role.kubernetes.io/master=\"\"\n[bootstraptoken] Using token: 14b539.de95fe444fb68be1\n[bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term ce
    rtificate credentials\n[bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token\n[bootstraptoken] Configured RBAC rules to allow certificat
    e rotation for all node client certificates in the cluster\n[bootstraptoken] Creating the \"cluster-info\" ConfigMap in the \"kube-public\" namespace\n[addons] Applied essential addon: kube-dns\n[addons] Applied
    essential addon: kube-proxy\n\nYour Kubernetes master has initialized successfully!\n\nTo start using your cluster, you need to run (as a regular user):\n\n  mkdir -p $HOME/.kube\n  sudo cp -i /etc/kubernetes/adm
    in.conf $HOME/.kube/config\n  sudo chown $(id -u):$(id -g) $HOME/.kube/config\n\nYou should now deploy a pod network to the cluster.\nRun \"kubectl apply -f [podnetwork].yaml\" with one of the options listed at:\
    n  http://kubernetes.io/docs/admin/addons/\n\nYou can now join any number of machines by running the following on each node\nas root:\n\n  kubeadm join --token 14b539.de95fe444fb68be1 192.168.1.36:6443 --discover
    y-token-ca-cert-hash sha256:c434bf7e451cc9deb43d941a58ab30bcce770f1e51f0c636a0f1add9888a11f4"
    }

    [...]

    TASK [nodes : Adding node to cluster] ***********************************************
    changed: [192.168.1.26]
    changed: [192.168.1.20]

    TASK [nodes : debug] ****************************************************************
    ok: [192.168.1.20] => {
        "msg": "[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.\n[preflight] Skipping pre-flight checks\n[validation] WARNING: using token-based discovery without DiscoveryTokenCACertHashes can be unsafe (see https://kubernetes.io/docs/admin/kubeadm/#kubeadm-join).\n[validation] WARNING: Pass --discovery-token-unsafe-skip-ca-verification to disable this warning. This warning will become an error in Kubernetes 1.9.\n[discovery] Trying to connect to API Server \"192.168.1.36:6443\"\n[discovery] Created cluster-info discovery client, requesting info from \"https://192.168.1.36:6443\"\n[discovery] Cluster info signature and contents are valid and no TLS pinning was specified, will use API Server \"192.168.1.36:6443\"\n[discovery] Successfully established connection with API Server \"192.168.1.36:6443\"\n[bootstrap] Detected server version: v1.8.5\n[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)\n\nNode join complete:\n* Certificate signing request sent to master and response\n  received.\n* Kubelet informed of new secure connection details.\n\nRun 'kubectl get nodes' on the master to see this machine join."
    }
    ok: [192.168.1.26] => {
        "msg": "[kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.\n[preflight] Skipping pre-flight checks\n[validation] WARNING: using token-based discovery without DiscoveryTokenCACertHashes can be unsafe (see https://kubernetes.io/docs/admin/kubeadm/#kubeadm-join).\n[validation] WARNING: Pass --discovery-token-unsafe-skip-ca-verification to disable this warning. This warning will become an error in Kubernetes 1.9.\n[discovery] Trying to connect to API Server \"192.168.1.36:6443\"\n[discovery] Created cluster-info discovery client, requesting info from \"https://192.168.1.36:6443\"\n[discovery] Cluster info signature and contents are valid and no TLS pinning was specified, will use API Server \"192.168.1.36:6443\"\n[discovery] Successfully established connection with API Server \"192.168.1.36:6443\"\n[bootstrap] Detected server version: v1.8.5\n[bootstrap] The server supports the Certificates API (certificates.k8s.io/v1beta1)\n\nNode join complete:\n* Certificate signing request sent to master and response\n  received.\n* Kubelet informed of new secure connection details.\n\nRun 'kubectl get nodes' on the master to see this machine join."
    }

    PLAY RECAP *************************************************************************
    192.168.1.20               : ok=27   changed=7    unreachable=0    failed=0
    192.168.1.26               : ok=27   changed=7    unreachable=0    failed=0
    192.168.1.36               : ok=37   changed=12   unreachable=0    failed=0


### Check cluster

    $ ansible-playbook -i inventory k8s.yml

    PLAY [Kubernetes informations] ********************************************************

    TASK [Gathering Facts] ****************************************************************
    ok: [192.168.1.36]

    TASK [kubernetes : Version] ***********************************************************
    changed: [192.168.1.36]

    TASK [kubernetes : Display version] ***************************************************
    ok: [192.168.1.36] => {
        "kubernetes_version.stdout_lines": [
            "Client Version: version.Info{Major:\"1\", Minor:\"8\", GitVersion:\"v1.8.5\", GitCommit:\"cce11c6a185279d037023e02ac5249e14daa22bf\", GitTreeState:\"clean\", BuildDate:\"2017-12-07T16:16:03Z\", GoVersion:\"go1.8.3\", Compiler:\"gc\", Platform:\"linux/arm\"}",
            "Server Version: version.Info{Major:\"1\", Minor:\"8\", GitVersion:\"v1.8.5\", GitCommit:\"cce11c6a185279d037023e02ac5249e14daa22bf\", GitTreeState:\"clean\", BuildDate:\"2017-12-07T16:05:18Z\", GoVersion:\"go1.8.3\", Compiler:\"gc\", Platform:\"linux/arm\"}"
        ]
    }

    TASK [kubernetes : Get nodes] *******************************************************
    changed: [192.168.1.36]

    TASK [kubernetes : Display nodes] ***************************************************
    ok: [192.168.1.36] => {
        "kubernetes_nodes.stdout_lines": [
            "NAME            STATUS     ROLES     AGE       VERSION",
            "jarvis-master   Ready      master    6m        v1.8.5",
            "jarvis-node1    NotReady   <none>    2m        v1.8.5",
            "jarvis-node2    Ready      <none>    2m        v1.8.5"
        ]
    }

    TASK [kubernetes : Get cluster info] ************************************************
    changed: [192.168.1.36]

    TASK [kubernetes : Display cluster info] ********************************************
    ok: [192.168.1.36] => {
        "kubernetes_clusterinfo.stdout_lines": [
            "\u001b[0;32mKubernetes master\u001b[0m is running at \u001b[0;33mhttps://192.168.1.36:6443\u001b[0m",
            "\u001b[0;32mKubeDNS\u001b[0m is running at \u001b[0;33mhttps://192.168.1.36:6443/api/v1/namespaces/kube-system/services/kube-dns/proxy\u001b[0m",
            "",
            "To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'."
        ]
    }

    PLAY RECAP *************************************************************************
    192.168.1.36               : ok=7    changed=3    unreachable=0    failed=0


### Destroy

	$ ansible-playbook -i inventory destroy.yml
