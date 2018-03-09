# Jarvis

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/zeiot%2Frasphome.svg)](https://badge.fury.io/gh/zeiot%2Frasphome)

* Master : [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/master.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/master)
* Develop: [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/develop.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/develop)

Features :

* [ ] Extract the energy consumption information from an EDF meter ([ERDF Teleinfo][])
* [ ] Analyze the indoor / outdoor temperature ([DHT22][])
* [ ] Measure air quality ([MQ135][])

Infrastructure :

* [x] Management of containerized applications using [Kubernetes][]
* [x] Monitoring solution with [Prometheus][] in the Kubernetes cluster
* [x] Dashboards using [Grafana][] in the Kubernetes cluster
* [x] Custom DNS using [CoreDNS][] (See [k8s/coredns/README.md]())
* [x] Home Assistant as the home automation platform

Home Assistant :

* [x] Extract the energy consumption information from an EDF meter ([ERDF Teleinfo][])
* [x] Analyze the indoor / outdoor temperature

![Dashboard](dashboard.png)

## Intallation

### Raspberry PI

See [docs/en/index.adoc](documentation)

### Cloud

You could use [Terraform](https://terraform.io) to deploy on a cloud provider :

| Provider       | Support      | Documentation                                    |
| -------------- | -----------  | ------------------------------------------------ |
| Google         | [x]          | [terraform/google/readme.adoc](documentation)    |
| Amazon         | [x]          | [terraform/aws/readme.adoc](documentation)       |
| Openstack      | [x]          | [terraform/openstack/readme.adoc](documentation) |
| Azure          | [ ]          |                                                  |


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

[HypriotOS]: http://blog.hypriot.com/

[Kubernetes]: https://kubernetes.io/
[Grafana]: http://grafana.org/
[Prometheus]: https://prometheus.io/
[CoreDNS]: https://coredns.io
[Home Assistant]: https://home-assistant.io/

[ERDF Teleinfo]: http://www.erdf.fr/sites/default/files/ERDF-NOI-CPT_02E.pdf
