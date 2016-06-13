# Jarvis server

## Development

* Initialize environment

        $ make init

* Build tool :

        $ make build

* Start the MQTT broker:

        $ docker run -p 1883:1883 --name mosquitto -d ansi/mosquitto

* Launch unit tests :

        $ make test
