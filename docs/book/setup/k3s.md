# Jarvis on ARM devices with k3s

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

Check dependencies and install dependencies :

```bash
$ make local-k3d-deps SETUP=k3d
$ mv k3d /usr/local/bin/
$ make local-k3d-check SETUP=k3d
[Jarvis] Local setup using k3d
[✅] k3d
```

Create the cluser :

```bash
$ make local-k3d-create SETUP=k3d
```
