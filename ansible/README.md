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

	$ ansible-playbook -i inventory k8s.yml
    $ ansible-playbook -i inventory master.yml
    $ ansible-playbook -i inventory nodes.yml

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
