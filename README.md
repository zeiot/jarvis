# HackHome

[![License Apache 2][badge-license]](LICENSE)
[![GitHub version](https://badge.fury.io/gh/zeiot%2Frasphome.svg)](https://badge.fury.io/gh/zeiot%2Frasphome)

* Extract the energy consumption information from an EDF meter ([ERDF Teleinfo][])
* Analyze the indoor / outdoor temperature

Requirements:

* [RaspberryPI][]
* [Arduino][]
* [Grafana][]
* [InfluxDB][]
* [Ansible][]


## Intallation

### Raspbian

Install the image into a SDCard:

    $ ./raspbian.sh sdbX


### Configuration

In file `/boot/cmdline.txt` delete line :

    console=ttyAMA0,115200 kgdboc=ttyAMA0,115200

In file `/etc/inittab`, comment line using *#* :

    T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100

Then reboot the Raspberry PI.

Configure the serial port and check inputs :

    $ stty -F /dev/ttyAMA0 1200 sane evenp parenb cs7 -crtscts
    $ cat /dev/ttyAMA0




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
[Grafana]: http://grafana.org/
[InfluxDB]: https://influxdata.com/

[ERDF Teleinfo]: http://www.erdf.fr/sites/default/files/ERDF-NOI-CPT_02E.pdf
