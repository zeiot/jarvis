# Kubernetes installation with Ansible

Ansible is used to setup:

* [Kubernetes](Kubernetes.md)

Prerequisite:

* unique MAC address
* unique machine_id

Use *debug.yml* to verify that.


## Install

Edit the **inventory** file :

	[master]
    <master_ip_address>         ansible_connection=ssh        ansible_user=pirate

	[nodes]
	<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
	<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
	<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate

Test :

	$ ansible all -m ping -i inventory

## Usage

### Debug Kubernetes hosts informations

    $ ansible-playbook -i inventory debug.yml

### Initialize hosts

    $ ansible-playbook -i inventory bootstrap.yml


### Setup

	$ ansible-playbook -i inventory site.yml

    PLAY [Kubernetes setup] *********************************************************************************************************

    TASK [Gathering Facts] **********************************************************************************************************
    ok: [192.168.1.26]
    ok: [192.168.1.20]
    ok: [192.168.1.36]

    TASK [base : Install base] ******************************************************************************************************
    included: /home/nlamirault/Perso/Zeiot/jarvis/ansible/roles/base/tasks/base.yml for 192.168.1.36, 192.168.1.20, 192.168.1.26

    TASK [base : Create a file to force apt-get to use IPv4 only] *******************************************************************
    ok: [192.168.1.20]
    ok: [192.168.1.26]
    ok: [192.168.1.36]

    TASK [base : Update cache] ******************************************************************************************************
    ok: [192.168.1.36]
    ok: [192.168.1.20]
    ok: [192.168.1.26]

    TASK [base : Install necessary tools] *******************************************************************************************
    ok: [192.168.1.26] => (item=[u'apt-transport-https', u'bash-completion', u'jq', u'nfs-common'])
    ok: [192.168.1.20] => (item=[u'apt-transport-https', u'bash-completion', u'jq', u'nfs-common'])
    ok: [192.168.1.36] => (item=[u'apt-transport-https', u'bash-completion', u'jq', u'nfs-common'])

    TASK [base : Configure system] **************************************************************************************************
    included: /home/nlamirault/Perso/Zeiot/jarvis/ansible/roles/base/tasks/system.yml for 192.168.1.36, 192.168.1.20, 192.168.1.26

    TASK [base : Set timezone] ******************************************************************************************************
    ok: [192.168.1.36]
    ok: [192.168.1.26]
    ok: [192.168.1.20]

    TASK [base : Update timezone] ***************************************************************************************************
    changed: [192.168.1.26]
    changed: [192.168.1.36]
    changed: [192.168.1.20]

    TASK [base : Configure Docker] **************************************************************************************************
    included: /home/nlamirault/Perso/Zeiot/jarvis/ansible/roles/base/tasks/docker.yml for 192.168.1.36, 192.168.1.20, 192.168.1.26

    TASK [base : Setup Docker to version 17.07.0~ce-0~raspbian (the latest supported by Kubernetes)] ********************************
    ok: [192.168.1.36]
    ok: [192.168.1.26]
    ok: [192.168.1.20]

    TASK [base : Downgrade docker] **************************************************************************************************
    ok: [192.168.1.36]
    ok: [192.168.1.26]
    ok: [192.168.1.20]

    TASK [base : Creates Docker systemd configuration directory] ********************************************************************
    ok: [192.168.1.36]
    ok: [192.168.1.26]
    ok: [192.168.1.20]

    TASK [base : Install Docker customization] **************************************************************************************
    ok: [192.168.1.26]
    ok: [192.168.1.36]
    ok: [192.168.1.20]

    TASK [base : Enable and restart Docker engine] **********************************************************************************
    changed: [192.168.1.26]
    changed: [192.168.1.20]
    changed: [192.168.1.36]

    TASK [base : Configure Kubernetes] **********************************************************************************************
    included: /home/nlamirault/Perso/Zeiot/jarvis/ansible/roles/base/tasks/kubernetes.yml for 192.168.1.36, 192.168.1.20, 192.168.1.26

    TASK [base : Add Kubernetes Repo Key] *******************************************************************************************
    ok: [192.168.1.20]
    ok: [192.168.1.26]
    ok: [192.168.1.36]

    TASK [base : Add Kubernetes Repo] ***********************************************************************************************
    ok: [192.168.1.20]
    ok: [192.168.1.26]
    ok: [192.168.1.36]

    TASK [base : Install Kubernetes components] *************************************************************************************
    changed: [192.168.1.26] => (item=[u'kubeadm=1.8.5-00', u'kubectl=1.8.5-00', u'kubelet=1.8.5-00', u'kubernetes-cni=0.6.0-00'])
    changed: [192.168.1.20] => (item=[u'kubeadm=1.8.5-00', u'kubectl=1.8.5-00', u'kubelet=1.8.5-00', u'kubernetes-cni=0.6.0-00'])
    changed: [192.168.1.36] => (item=[u'kubeadm=1.8.5-00', u'kubectl=1.8.5-00', u'kubelet=1.8.5-00', u'kubernetes-cni=0.6.0-00'])

    TASK [base : stat] **************************************************************************************************************
    ok: [192.168.1.20]
    ok: [192.168.1.36]
    ok: [192.168.1.26]

    TASK [base : command] ***********************************************************************************************************
    skipping: [192.168.1.36]
    skipping: [192.168.1.20]
    skipping: [192.168.1.26]

    TASK [base : Enable and start kubelet] ******************************************************************************************
    ok: [192.168.1.20]
    ok: [192.168.1.26]
    ok: [192.168.1.36]

    TASK [base : Setup IPv4 traffic] ************************************************************************************************
    changed: [192.168.1.20]
    changed: [192.168.1.36]
    changed: [192.168.1.26]

    PLAY [Kubernetes master configuration] ******************************************************************************************

    TASK [Gathering Facts] **********************************************************************************************************
    ok: [192.168.1.36]

    TASK [master : Reset Kubernetes] ************************************************************************************************
    changed: [192.168.1.36]

    TASK [master : Check kubelet state] *********************************************************************************************
    changed: [192.168.1.36]

    TASK [master : Generate cluster token] ******************************************************************************************
    changed: [192.168.1.36]

    TASK [master : debug] ***********************************************************************************************************
    ok: [192.168.1.36] => {
        "msg": "Kubernetes token: 4cfe9d.3d7d05273e9222a1"
    }

    TASK [master : set_fact] ********************************************************************************************************
    ok: [192.168.1.36]

    TASK [master : Initialize cluster] **********************************************************************************************
    changed: [192.168.1.36]

    TASK [master : debug] ***********************************************************************************************************
    ok: [192.168.1.36] => {
        "msg": "Kubernetes init: [kubeadm] WARNING: kubeadm is in beta, please do not use it for production clusters.\n[init] Using Kubernetes version: v1.8.5\n[init] Using Authorization modes: [Node RBAC]\n[preflight] Skipping pre-flight checks\n[kubeadm] WARNING: starting in 1.8, tokens expire after 24 hours by default (if you require a non-expiring token use --token-ttl 0)\n[certificates] Generated ca certificate and key.\n[certificates] Generated apiserver certificate and key.\n[certificates] apiserver serving cert is signed for DNS names [jarvis-master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.1.36]\n[certificates] Generated apiserver-kubelet-client certificate and key.\n[certificates] Generated sa key and public key.\n[certificates] Generated front-proxy-ca certificate and key.\n[certificates] Generated front-proxy-client certificate and key.\n[certificates] Valid certificates and keys now exist in \"/etc/kubernetes/pki\"\n[kubeconfig] Wrote KubeConfig file to disk: \"admin.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"kubelet.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"controller-manager.conf\"\n[kubeconfig] Wrote KubeConfig file to disk: \"scheduler.conf\"\n[controlplane] Wrote Static Pod manifest for component kube-apiserver to \"/etc/kubernetes/manifests/kube-apiserver.yaml\"\n[controlplane] Wrote Static Pod manifest for component kube-controller-manager to \"/etc/kubernetes/manifests/kube-controller-manager.yaml\"\n[controlplane] Wrote Static Pod manifest for component kube-scheduler to \"/etc/kubernetes/manifests/kube-scheduler.yaml\"\n[etcd] Wrote Static Pod manifest for a local etcd instance to \"/etc/kubernetes/manifests/etcd.yaml\"\n[init] Waiting for the kubelet to boot up the control plane as Static Pods from directory \"/etc/kubernetes/manifests\"\n[init] This often takes around a minute; or longer if the control plane images have to be pulled.\n[apiclient] All control plane components are healthy after 174.515507 seconds\n[uploadconfig] Storing the configuration used in ConfigMap \"kubeadm-config\" in the \"kube-system\" Namespace\n[markmaster] Will mark node jarvis-master as master by adding a label and a taint\n[markmaster] Master jarvis-master tainted and labelled with key/value: node-role.kubernetes.io/master=\"\"\n[bootstraptoken] Using token: 4cfe9d.3d7d05273e9222a1\n[bootstraptoken] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials\n[bootstraptoken] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token\n[bootstraptoken] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster\n[bootstraptoken] Creating the \"cluster-info\" ConfigMap in the \"kube-public\" namespace\n[addons] Applied essential addon: kube-dns\n[addons] Applied essential addon: kube-proxy\n\nYour Kubernetes master has initialized successfully!\n\nTo start using your cluster, you need to run (as a regular user):\n\n  mkdir -p $HOME/.kube\n  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config\n  sudo chown $(id -u):$(id -g) $HOME/.kube/config\n\nYou should now deploy a pod network to the cluster.\nRun \"kubectl apply -f [podnetwork].yaml\" with one of the options listed at:\n  http://kubernetes.io/docs/admin/addons/\n\nYou can now join any number of machines by running the following on each node\nas root:\n\n  kubeadm join --token 4cfe9d.3d7d05273e9222a1 192.168.1.36:6443 --discovery-token-ca-cert-hash sha256:4bc5704287f5084380f08a37a705ff87b0a3bc5d16dd4c2a35fb6b99f220a2f3"
    }

    TASK [master : Wait for admin pods are started] *********************************************************************************
    Pausing for 180 seconds
    (ctrl+C then 'C' = continue early, ctrl+C then 'A' = abort)
    ok: [192.168.1.36]

    TASK [master : Retrieve Kubernetes version] *************************************************************************************
    changed: [192.168.1.36]

    TASK [master : debug] ***********************************************************************************************************
    ok: [192.168.1.36] => {
        "msg": "Kubernetes version: Q2xpZW50IFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiI4IiwgR2l0VmVyc2lvbjoidjEuOC41IiwgR2l0Q29tbWl0OiJjY2UxMWM2YTE4NTI3OWQwMzcwMjNlMDJhYzUyNDllMTRkYWEyMmJmIiwgR2l0VHJlZVN0YXRlOiJjbGVhbiIsIEJ1aWxkRGF0ZToiMjAxNy0xMi0wN1QxNjoxNjowM1oiLCBHb1ZlcnNpb246ImdvMS44LjMiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYXJtIn0KU2VydmVyIFZlcnNpb246IHZlcnNpb24uSW5mb3tNYWpvcjoiMSIsIE1pbm9yOiI4IiwgR2l0VmVyc2lvbjoidjEuOC41IiwgR2l0Q29tbWl0OiJjY2UxMWM2YTE4NTI3OWQwMzcwMjNlMDJhYzUyNDllMTRkYWEyMmJmIiwgR2l0VHJlZVN0YXRlOiJjbGVhbiIsIEJ1aWxkRGF0ZToiMjAxNy0xMi0wN1QxNjowNToxOFoiLCBHb1ZlcnNpb246ImdvMS44LjMiLCBDb21waWxlcjoiZ2MiLCBQbGF0Zm9ybToibGludXgvYXJtIn0K"
    }

    TASK [master : Install Weavenet network add-on] *********************************************************************************
    changed: [192.168.1.36]

    PLAY RECAP **********************************************************************************************************************
    192.168.1.20               : ok=21   changed=4    unreachable=0    failed=0
    192.168.1.26               : ok=21   changed=4    unreachable=0    failed=0
    192.168.1.36               : ok=33   changed=10   unreachable=0    failed=0


### Update

	$ ansible-playbook -i inventory update.yml


### Destroy

	$ ansible-playbook -i inventory destroy.yml
