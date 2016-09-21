# Copyright (C) 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

APP = jarvis
VERSION = 0.2.0

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-15s\033[0m

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) [$(VERSION)] ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: clean
clean: ## clean installation
	platformio run -d arduino/dht --target clean
	platformio run -d arduino/photocell --target clean
	platformio run -d arduino/teleinfo --target clean

#
# Raspberry PI
#

.PHONY: rpi-create
rpi-create: ## Create the Raspberry PI SDCard (sdb=sdbXXX)
	@raspberrypi/raspbian.sh $(sdb)

.PHONY: rpi-k8s
rpi-k8s: ## Initialize components on the Raspberry PI (master=x.x.x.x)
	@./kubectl create -f k8s/config/namespace-jarvis.yaml -s 192.x.x.x
	@echo -e"$(OK_COLOR)Go to : $(server)$(NO_COLOR)"
#
# Arduino
#

.PHONY: arduino-init
arduino-init: ## Initialize Arduino environment
	virtualenv --python=/usr/bin/python2 venv && \
		. venv/bin/activate && pip install platformio==3.1.0
	echo -e "$(OK_COLOR)Active your PlatformIO environment: $ . venv/bin/activate$(NO_COLOR)"

.PHONY: arduino-list
arduino-list: ## List serial ports
	platformio device list

.PHONY: arduino-monitor
arduino-monitor: ## serial port monitor ('ctrl+]' to quit)
	platformio device monitor

.PHONY: arduino-build
arduino-build: ## Build project (project=xxx)
	platformio run -d $(project)

.PHONY: arduino-test
arduino-test: ## Test project (project=xxx)
	platformio test -d $(project)

.PHONY: arduino-upload
arduino-upload: ## Build and upload project (project=xxx)
	platformio run -d $(project) --target upload

.PHONY: arduino-ci
arduino-ci: ## Launch unit tests
	platformio ci arduino/dht/src/jarvis-dht.ino \
		--lib=arduino/dht/lib/ESP8266wifi_ID1101 \
		--lib=arduino/dht/lib/PubSubClient_ID89  \
		--lib=arduino/dht/lib/Adafruit_DHT_ID19 \
		--board=uno
	platformio ci arduino/teleinfo/src/jarvis-teleinfo.ino \
		--lib=arduino/teleinfo/lib/ESP8266wifi_ID1101 \
		--lib=arduino/teleinfo/lib/PubSubClient_ID89  \
		--lib=arduino/teleinfo/lib/LibTeleinfo_ID214 \
		--board=uno

#
# Kubernetes
#

.PHONY: k8s-deps
k8s-deps: ## Retrieve Kubernetes dependencies
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.10.0/minikube-linux-amd64 && \
		chmod +x minikube
	curl -Lo kubectl http://storage.googleapis.com/kubernetes-release/release/v1.3.0/bin/linux/amd64/kubectl && \
		chmod +x kubectl

.PHONY: k8s-init
k8s-init: ## Initialize development environment
	./minikube --vm-driver=virtualbox start

.PHONY: k8s-destroy
k8s-destroy: ## Destroy the development environment
	./minikube delete
