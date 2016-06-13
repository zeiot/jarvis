# Jarvis

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/zeiot%2Frasphome.svg)](https://badge.fury.io/gh/zeiot%2Frasphome)


Master :
* [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/master.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/master)

Develop:
* [![Circle CI](https://circleci.com/gh/zeiot/jarvis/tree/develop.svg?style=svg)](https://circleci.com/gh/zeiot/jarvis/tree/develop)

Features :

* Extract the energy consumption information from an EDF meter ([ERDF Teleinfo][])
* Analyze the indoor / outdoor temperature ([DHT22][])

Requirements:

* [RaspberryPI][]
* [Arduino][]
* [Mosquitto][]
* [Grafana][]
* [InfluxDB][]
* [Ansible][]
* [PlatformIO][]

![Architecture](https://cdn.rawgit.com/zeiot/jarvis/develop/jarvis.svg)

## Intallation

### Raspberry PI

Install the image into a SDCard:

    $ ./raspbian.sh sdbX


### Arduino

For *arduino* projects, you could :

* build all projects :

        $ make arduino-build-all

* build single project (for example dht):

        $ make arduino-build project=arduino/dht

#### DHT

#### Teleinfo



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
[Arduino]: https://www.arduino.cc/
[Mosquitto]: http://mosquitto.org/
[Grafana]: http://grafana.org/
[InfluxDB]: https://influxdata.com/
[Ansible]: https://www.ansible.com/
[PlatformIO]: http://platformio.org/

[ERDF Teleinfo]: http://www.erdf.fr/sites/default/files/ERDF-NOI-CPT_02E.pdf
[DHT22]: https://www.adafruit.com/products/385
