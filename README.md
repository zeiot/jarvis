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

    $ sdcard/jarvis.sh jarvis myssid mywifipassword Linux

Log into the OS:

    $ ssh pirate@x.x.x.x
    HypriotOS/armv7: pirate@jarvis in ~
    $ curl -LO --progress-bar https://raw.githubusercontent.com/zeiot/jarvis/refactoring/sdcard/jarvis_k8s.sh
    $ chmod +x jarvis_k8s.sh
    $ ./jarvis_k8s.sh

Create the Jarvis namespace into Kubernetes:

    $ kubectl create -f k8s/config/namespace-jarvis.yaml -s 192.x.x.x


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

