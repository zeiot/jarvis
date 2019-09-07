# Jarvis

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/zeiot%2Frasphome.svg)](https://badge.fury.io/gh/zeiot%2Frasphome)

* Master : [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/master.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/master)
* Develop: [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/develop.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/develop)

Kubernetes infrastructure

![architecture](docs/assets/images/jarvis.png)

## Kubernetes cluster

&nbsp;

### Homelab ARM64

&nbsp;

### GKE

<img width=86 height=86 align="left" src="docs/assets/images/gke.png">

GKE (Google Kubernetes Engine) provides our Kubernetes cluster on Google Cloud

See [kubernetes/gke/](gke)

&nbsp;

### EKS

<img width=86 height=86 align="left" src="docs/assets/images/eks.png">

Amazon EKS provides our Kubernetes cluster on Amazon AWS

See [kubernetes/eks](eks)

&nbsp;

### AKS

<img width=86 height=86 align="left" src="docs/assets/images/aks.png">

AKS provides our Kubernetes cluster on Microsoft Azure Kubernetes Service

**TODO**
&nbsp;


## Monitoring

### Prometheus

<img width=86 height=86 align="left" src="docs/assets/images/prometheus.png">

Prometheus is used as the time series database for monitoring system

&nbsp;

### Grafana

<img width=86 height=86 align="left" src="docs/assets/images/grafana.png">

Grafana is the UI of monitoring

&nbsp;

## CI/CD

### Tekton

<img width=86 height=86 align="left" src="docs/assets/images/tekton.png">

The Tekton Pipelines project provides Kubernetes-style resources for declaring CI/CD-style pipelines.

&nbsp;

### Kaniko

<img width=86 height=86 align="left" src="docs/assets/images/kaniko.png">

Kaniko enables the build of OCI compliant containers without using the Docker daemon.

&nbsp;


## Serverless

&nbsp;

### Knative

<img width=86 height=86 align="left" src="docs/assets/images/knative.png">

Knative components build on top of Kubernetes,

&nbsp;


## Networking

### PiHole

<img width=86 height=86 align="left" src="docs/assets/images/pihole.png">

An advertisement and Internet tracker blocking application which acts as a DNS sinkhole.

&nbsp;

### ExternalDNS

<img width=86 height=86 align="left" src="docs/assets/images/externaldns.png">

Makes Ingresses and Services available via DNS

&nbsp;


## Multimedia

&nbsp;

### Films

<img width=86 height=86 align="left" src="docs/assets/images/radarr.png">

Automatically downloading movies via Usenet and BitTorrent.

&nbsp;

### TV

<img width=86 height=86 align="left" src="docs/assets/images/sonarr.png">

A PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them

&nbsp;


## Tools

&nbsp;

### Kustomize

<img width=86 height=86 align="left" src="docs/assets/images/kustomize.png">

For the management of Kubernetes resources, kustomize is used.

&nbsp;


## Installation

&nbsp;


## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

&nbsp;


## License

See [LICENSE](LICENSE) for the complete license.

&nbsp;


## Changelog

A [changelog](ChangeLog.md) is available

&nbsp;


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>


[badge-license]: https://img.shields.io/badge/license-Apache2-green.svg?style=flat

[RaspberryPI]: https://www.raspberrypi.org/

[HypriotOS]: http://blog.hypriot.com/

[Kubernetes]: https://kubernetes.io/
[Grafana]: http://grafana.org/
[Prometheus]: https://prometheus.io/
[CoreDNS]: https://coredns.io
[Home Assistant]: https://home-assistant.io/

[ERDF Teleinfo]: http://www.erdf.fr/sites/default/files/ERDF-NOI-CPT_02E.pdf
