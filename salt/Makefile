# Copyright (C) 2016-2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

APP="Jarvis / Salt"

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-30s\033[0m

SHELL = /bin/bash

.DEFAULT_GOAL := help


.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) [$(VERSION)] ====$(NO_COLOR)"
	@grep -E '^[0-9a-zA-Z_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: hosts
hosts: ## Display available hosts
	@echo -e "$(OK_COLOR)[$(APP)] Display available hosts$(NO_COLOR)"
	sudo salt-key -L

.PHONY: check
check: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Check hosts$(NO_COLOR)"
	@sudo salt '*' test.ping
	@sudo salt '*' test.version
	@sudo salt '*' status.uptime

.PHONY: k8s-check
k8s-check: ## Check Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Check hosts$(NO_COLOR)"
	@sudo salt -C 'G@osarch:arm64' cmd.run 'dpkg -l|grep docker-ce'
	@sudo salt -C 'G@osarch:arm64' cmd.run 'dpkg -l|grep kube*'

.PHONY: commons
commons: ## Perform configuration
	@echo -e "$(OK_COLOR)[$(APP)] Configure hosts$(NO_COLOR)"
	@sudo salt '*' state.apply

.PHONY: k8s-setup
k8s-setup: ## Setup a Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Setup Kubernetes cluster$(NO_COLOR)"
	@sudo salt '*' state.sls kubernetes

.PHONY: monitoring
monitoring: ## Setup monitoring tools
	@echo -e "$(OK_COLOR)[$(APP)] Setup monitoring$(NO_COLOR)"
	@sudo salt '*' state.sls monitoring
