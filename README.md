# Jarvis

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/zeiot%2Frasphome.svg)](https://badge.fury.io/gh/zeiot%2Frasphome)

* Master : [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/master.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/master)
* Develop: [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/develop.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/develop)

Features :

* Extract the energy consumption information from an EDF meter ([ERDF Teleinfo][])
* Analyze the indoor / outdoor temperature ([DHT22][])
* Measure air quality ([MQ135][])
* Monitoring a Synology NAS using SNMP

Tools :

* Management of containerized applications using [Kubernetes][]
* Monitoring solution with [Prometheus][]
* Dashboards using [Grafana][]

Requirements:

* [RaspberryPI][]
* [Arduino][]

![Architecture](jarvis.png)

## Intallation

### Raspberry PI

Install [Kubernetes][] with [HypriotOS][] onto the SDCard:

    $ sdcard/jarvis_os_2.sh jarvis myssid mywifipassword Linux

Log into the OS:

    $ ssh pirate@x.x.x.x
    HypriotOS/armv7: pirate@jarvis in ~
    $ curl -LO --progress-bar https://raw.githubusercontent.com/zeiot/jarvis/refactoring/sdcard/jarvis_k8s.sh
    $ chmod +x jarvis_k8s.sh
    $ export MASTER_IP=192.168.1.23
    $ sudo ./jarvis_k8s.sh

Use *overlay2* storage driver for Docker. Edit '''/etc/docker/daemon.json''' file: 

    ```json
    {
      "storage-driver": "overlay2"
    }
    ```

    $ sudo systemctl daemon-reload 
    $ sudo systemctl start docker
    $ docker info|grep "Storage Driver"
    Storage Driver: overlay2

Install Kubernetes components :

    $ sudo apt update && sudo apt install -y apt-transport-https
    $ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    $ sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
    deb http://apt.kubernetes.io/ kubernetes-xenial main
    EOF
    $ sudo apt update
    # Install docker if you don't have it already.
    $ sudo apt install kubectl=1.7.4-00 kubeadm=1.7.4-00 kubelet=1.7.4-00 kubernetes-cni=0.5.1-00

Initialize the master : 

    $ sudo kubeadm init --kubernetes-version v1.7.4 --apiserver-advertise-address=192.168.1.23 --pod-network-cidr=10.244.0.0/16 --skip-preflight-checks 


Extract the *token* from line :

    $ kubeadm join --token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Setup installation :

    $ mkdir -p $HOME/.kube
    $ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    $ sudo chown $(id -u):$(id -g) $HOME/.kube/config

Install *weave-net* :

    $ kubectl apply -n kube-system -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    clusterrole "weave-net" created
    serviceaccount "weave-net" created
    clusterrolebinding "weave-net" created
    daemonset "weave-net" created

Install the dashboard :

    $ wget https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
    $ sed -i "s/amd64/arm/g" kubernetes-dashboard.yaml
    $ kubectl create -f  kubernetes-dashboard.yaml
    $  kubectl describe services kubernetes-dashboard --namespace=kube-system`

After a few minutes, check the installation:

    $ kubectl cluster-info
    Kubernetes master is running at http://localhost:8080
    KubeDNS is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-dns
    kubernetes-dashboard is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard

    $ kubectl get nodes
    NAME           STATUS    AGE
    192.168.1.23   Ready     27m

Before to add a new node, generate a new machineid, see : https://github.com/hypriot/image-builder-rpi/issues/167

Then add a new node :

    $ sudo kubeadm join --token ${TOKEN} ${MASTER_IP}:6443

Check status of nodes a few minutes later :

    $ kubectl get nodes
    NAME           STATUS    AGE       VERSION
    jarvis         Ready     23h       v1.6.5
    jarvis-node1   Ready     5m        v1.6.5

Install Heapster :

    $ kubectl create -f k8s/heapster/
    serviceaccount "heapster" created
    clusterrolebinding "heapster" created
    deployment "heapster" created
    service "heapster" created

    $ kubectl get svc --namespace=kube-system
    NAME                   CLUSTER-IP       EXTERNAL-IP   PORT(S)         AGE
    heapster               10.105.246.100   <none>        80/TCP          8m
    kube-dns               10.96.0.10       <none>        53/UDP,53/TCP   11d
    kubernetes-dashboard   10.111.120.27    <none>        80/TCP          11d

    $ kubectl get pods --namespace=kube-system
    NAME                                    READY     STATUS    RESTARTS   AGE
    etcd-jarvis                             1/1       Running   1          11d
    heapster-1289448017-s6qmt               1/1       Running   0          8m
    kube-apiserver-jarvis                   1/1       Running   2          11d
    kube-controller-manager-jarvis          1/1       Running   1          11d
    kube-dns-1351932519-x7s3h               3/3       Running   0          11d
    kube-proxy-1vl3p                        1/1       Running   1          11d
    kube-proxy-20mnd                        1/1       Running   0          11d
    kube-scheduler-jarvis                   1/1       Running   1          11d
    kubernetes-dashboard-1656946765-zv5z9   1/1       Running   0          11d
    tiller-deploy-2149868908-l848t          1/1       Running   0          3d
    weave-net-3zc8d                         2/2       Running   1          11d
    weave-net-mn9jc                         2/2       Running   0          11d

Check nodes states :

    $ kubectl top nodes
    NAME           CPU(cores)   CPU%      MEMORY(bytes)   MEMORY%
    jarvis         695m         17%       610Mi           80%
    jarvis-node1   1532m        38%       470Mi           61%

Create the Jarvis namespace into Kubernetes:

    $ kubectl create -f k8s/config/namespace-jarvis.yaml -s 192.x.x.x

Configure the Jarvis context:

    $ kubectl config set-context jarvis --namespace=jarvis
    context "jarvis" set.
    $ kubectl config use-context jarvis
    switched to context "jarvis".
    $ kubectl config current-context
    jarvis

### Cloud

You could use [Packer](https://packer.io) to create cloud image with Kubernetes installed.
See :

| Provider       | Support      | Version     |
| -------------- | -----------  | ------------|
| GCE            | [x]          | 1.6.5       |
| EC2            | [x]          | 1.6.5       |
| DigitalOcean   | [x]          | 1.6.5       |
| Azure          | [ ]          |             |

You could use [Terraform](https://terraform.io) to deploy some nodes.



## Arduino

* For *arduino* projects, we use [PlatformIO][], initialize it:

        $ make arduino-init

* For project (here *dht*) setup arduino devices client configurations:

        $ cp arduino/dht/src/config.sample.h arduino/dht/src/config.h
        # edit config.h to customize your requirements

* Build project (for example dht):

        $ make arduino-build project=arduino/dht

* Connect an Arduino, then upload it :

        $ make arduino-upload project=arduino/dht


## Synology

Configure the SNMP on the Synology NAS. Go to the Control Panel, choose Terminal & SNMP and make the configuration on the SNMP tab (Choose SNMP v1).


## Development

See [DEV](DEV.md)


## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).


## License

See [LICENSE](LICENSE) for the complete license.


## Changelog

A [changelog](ChangeLog.md) is available


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>




[badge-license]: https://img.shields.io/badge/license-Apache2-green.svg?style=flat

[RaspberryPI]: https://www.raspberrypi.org/
[PlatformIO]: http://platformio.org/
[Arduino]: https://www.arduino.cc/

[HypriotOS]: http://blog.hypriot.com/

[Kubernetes]: https://kubernetes.io/
[Mosquitto]: https://mosquitto.org/
[Grafana]: http://grafana.org/
[Prometheus]: https://prometheus.io/

[Ansible]: https://www.ansible.com/

[ERDF Teleinfo]: http://www.erdf.fr/sites/default/files/ERDF-NOI-CPT_02E.pdf
[DHT22]: https://www.adafruit.com/products/385
[MQ135]: https://www.olimex.com/Products/Components/Sensors/SNS-MQ135/
