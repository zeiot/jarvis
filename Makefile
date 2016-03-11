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
VERSION = 0.1.0

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
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: clean
clean: ## clean installation
	platformio run -d arduino/dht --target clean
	platformio run -d arduino/teleinfo --target clean
	@rm -fr venv

.PHONY: init
init: ## Initialize environment
	virtualenv --python=/usr/bin/python2 venv && \
		. venv/bin/activate && pip install platformio

#
# Raspberry PI
#

.PHONY: rasp-create
rasp-install: ## Create the Raspberry PI SDCard (sdb=sdbXXX)
	@raspberrypi/raspbian.sh $(sdb)

#
# Arduino
#

.PHONY: arduino-test
arduino-test: ## Launch unit tests
	platformio ci arduino/dht/src/jarvis-dht.ino --lib=arduino/dht/lib/DHT --board=uno
	platformio ci arduino/teleinfo/src/jarvis-teleinfo.ino --board=uno

.PHONY: arduino-run
arduino-run: ## Build projects
	platformio run -d arduino/dht
	platformio run -d arduino/teleinfo

.PHONY: arduino-upload
arduino-upload: ## Build and upload projects
	platformio run -d arduino/dht --target upload
	platformio run -d arduino/teleinfo --target upload

#
# API Server
#

.PHONY: server-build
server-build:  ## Build the Jarvis Server
	@cd server && make build

.PHONY: server-run
server-run: ## Run the Jarvis server
	@server/jarvis-server

.PHONY: server-exe
server-exe: ## Create the Jarvis server executable
	@cd server && make gox
