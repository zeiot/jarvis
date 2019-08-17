# Jarvis on ARM devices with kubeadm

## Description

### Hardware choices

* 1x Rock64 4Go RAM for the master
* 3x Raspberry PI 3 for workers
* 3x [PiBlox Cases](https://www.amazon.com/gp/product/B017Z32E6M/ref=oh_aui_detailpage_o08_s00?ie=UTF8&psc=1)
* [Ethernet cables](https://www.amazon.com/gp/product/B0056ZSF74/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1)
* [Micro USB cables](https://www.amazon.com/gp/product/B01MRH8P7E/ref=oh_aui_detailpage_o00_s00?ie=UTF8&psc=1)
* [ORICO USB2.0 HUB](https://www.amazon.com/gp/product/B00JP47EFG/ref=oh_aui_detailpage_o00_s01?ie=UTF8&psc=1)
* 4x 32GB memory cards

### Network

* Network: **192.168.1.0/24**
* Gateway: **192.168.1.1**
* DNS: **192.168.1.1**

### Kubernetes Nodes

* Master1: **192.168.1.36**
* Node1: **192.168.1.20**
* Node2: **192.168.1.26**
* Node3: **192.168.1.29**

### MetalLB CIDR

* Cidr **192.168.1.224/27**
* Min: **192.168.1.225**
* Max: **192.168.1.254**

## Setup

### Operating system

Install the operating system (Debian Stretch) on the master:

```bash
$ ./sdcard/jarvis_master_os.sh -s /dev/mmcblk0
== Jarvis OS: Rock64 Stretch 0.5.15 ==
Download OS image
Install OS on /dev/mmcblk0
2218786816 bytes (2.2 GB, 2.1 GiB) copied, 10 s, 222 MB/s
544+1 records in
544+1 records out
2282749952 bytes (2.3 GB, 2.1 GiB) copied, 42.0649 s, 54.3 MB/s
== Done ==
```

Install https://github.com/hypriot/image-builder-rpi/releases[HypriotOS] onto
the sdcard:

```bash
$ sdcard/jarvis_os_2.sh jarvis myssid mywifipassword Linux
```

Generate a new machineid on each host, see : https://github.com/hypriot/image-builder-rpi/issues/167

### Ansible

[Ansible][ansible] is used to configure the *Salt* infrastructure.

Go into the *ansible* directory and create an *inventory* file:

Example, my personal configuration is :

* a kubernetes cluster (Rock64 as master, 3 RPI3 as nodes)
* PI ZeroW as Home Assistant server
* PI3 as a multimedia server (OSMC)

```bash
[master]
<master_ip_address>         ansible_connection=ssh        ansible_user=pirate

[nodes]
<node1_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node2_ip_address>          ansible_connection=ssh        ansible_user=pirate
<node3_ip_address>          ansible_connection=ssh        ansible_user=pirate

[osmc]
<osmc_ip_address>          ansible_connection=ssh        ansible_user=pirate
```

You could now check communications with hosts:

```bash
$ make check
```

[ansible]: https://www.ansible.com/

### Saltstack

Saltstack is used to manage all hosts.
Install the master :

```bash
$ make salt-master
```

and the minions :

```bash
$ make salt-minions
```

On the master accepts minions keys. See [salk-key][https://docs.saltstack.com/en/latest/ref/cli/salt-key.html]

On the master :

```bash
$ cd /srv/jarvis
$ make check
$ make hosts
```

Install Kubernetes dependencies :

```bash
$ make k8s-setup
```

You could check hosts setup :

```bash
$ make k8s-check
[Jarvis / Salt] Check hosts
jarvis-master:
    ii  docker-ce                                                       18.06.1~ce~3-0~ubuntu                    arm64        Docker: the open-source application container engine
jarvis-node3.localdomain:
    ii  docker-ce                     18.06.1~ce~3-0~debian          arm64        Docker: the open-source application container engine
jarvis-node2.localdomain:
    ii  docker-ce                     18.06.1~ce~3-0~debian          arm64        Docker: the open-source application container engine
jarvis-node1.localdomain:
    ii  docker-ce                     18.06.1~ce~3-0~debian          arm64        Docker: the open-source application container engine
jarvis-master:
    ii  kubeadm                                                         1.13.3-00                                arm64        Kubernetes Cluster Bootstrapping Tool
    ii  kubectl                                                         1.13.3-00                                arm64        Kubernetes Command Line Tool
    ii  kubelet                                                         1.13.3-00                                arm64        Kubernetes Node Agent
    ii  kubernetes-cni                                                  0.6.0-00                                 arm64        Kubernetes CNI
jarvis-node2.localdomain:
    ii  kubeadm                       1.13.3-00                      arm64        Kubernetes Cluster Bootstrapping Tool
    ii  kubectl                       1.13.3-00                      arm64        Kubernetes Command Line Tool
    ii  kubelet                       1.13.3-00                      arm64        Kubernetes Node Agent
    ii  kubernetes-cni                0.6.0-00                       arm64        Kubernetes CNI
jarvis-node3.localdomain:
    ii  kubeadm                       1.13.3-00                      arm64        Kubernetes Cluster Bootstrapping Tool
    ii  kubectl                       1.13.3-00                      arm64        Kubernetes Command Line Tool
    ii  kubelet                       1.13.3-00                      arm64        Kubernetes Node Agent
    ii  kubernetes-cni                0.6.0-00                       arm64        Kubernetes CNI
jarvis-node1.localdomain:
    ii  kubeadm                       1.13.3-00                      arm64        Kubernetes Cluster Bootstrapping Tool
    ii  kubectl                       1.13.3-00                      arm64        Kubernetes Command Line Tool
    ii  kubelet                       1.13.3-00                      arm64        Kubernetes Node Agent
    ii  kubernetes-cni                0.6.0-00                       arm64        Kubernetes CNI
```


