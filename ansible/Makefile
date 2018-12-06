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

APP="Jarvis / Ansible"

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-30s\033[0m

SHELL = /bin/bash

.DEFAULT_GOAL := help


.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
	@grep -E '^[0-9a-zA-Z_\-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: check
check: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Check hosts$(NO_COLOR)"
	@ansible all -m ping -i inventory

.PHONY: debug
debug: ## Display some informations about hosts
	@echo -e "$(OK_COLOR)[$(APP)] Retrieve informations$(NO_COLOR)"
	@ansible-playbook -i inventory debug.yml

.PHONY: bootstrap
bootstrap: ## Bootstrap the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Bootstrap the cluster$(NO_COLOR)"
	@ansible-playbook -i inventory bootstrap.yml

.PHONY: destroy
destroy: ## Destroy the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Destroy the cluster$(NO_COLOR)"
	@ansible-playbook -i inventory destroy.yml

.PHONY: k8s-setup
k8s-setup: ## Setup the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Setup the cluster$(NO_COLOR)"
	@ansible-playbook -i inventory k8s.yml \
	    && ansible-playbook -i inventory master.yml \
	    && ansible-playbook -i inventory nodes.yml

.PHONY: k8s-status
k8s-status: ## Check the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Check the cluster$(NO_COLOR)"
	@ansible-playbook -i inventory cluster.yml

.PHONY: salt-master
salt-master: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Configure Salt infra$(NO_COLOR)"
	@ansible-playbook -i inventory salt-master.yml

.PHONY: salt-minions
salt-minions: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Configure Salt infra$(NO_COLOR)"
	@ansible-playbook -i inventory salt-minions.yml
