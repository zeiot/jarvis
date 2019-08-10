# Copyright (C) 2016-2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

APP = Jarvis

ANSIBLE_DIR = ansible
SALT_DIR = salt

KUBE_CONTEXT=kube-jarvis

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-20s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) / BareMetal / Homelab ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'


guard-%:
	@if [ "${${*}}" = "" ]; then \
		echo -e "$(ERROR_COLOR)Environment variable $* not set$(NO_COLOR)"; \
		exit 1; \
	fi

print-%:
	@if [ "${$*}" == "" ]; then \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) $* = ${$*}"; \
	else \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) $* = ${$*}"; \
	fi


# ====================================
# A N S I B L E
# ====================================


.PHONY: homelab-check
homelab-check: print-GOOGLE_APPLICATION_CREDENTIALS ## Check requirements
	@if $$(hash ansible 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) ansible"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) ansible"; \
	fi

.PHONY: homelab-ping
homelab-ping: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Check hosts$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible all -m ping -i inventory

.PHONY: homelab-debug
homelab-debug: ## Display some informations about hosts
	@echo -e "$(OK_COLOR)[$(APP)] Retrieve informations$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory debug.yml

.PHONY: homelab-bootstrap
homelab-bootstrap: ## Bootstrap the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Bootstrap the cluster$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory bootstrap.yml

.PHONY: homelab-destroy
homelab-destroy: ## Destroy the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Destroy the cluster$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory destroy.yml

# .PHONY: homelab-setup
# homelab-setup: ## Setup the Kubernetes cluster
# 	@echo -e "$(OK_COLOR)[$(APP)] Setup the cluster$(NO_COLOR)"
# 	@ansible-playbook -i inventory k8s.yml \
# 	    && ansible-playbook -i inventory master.yml \
# 	    && ansible-playbook -i inventory nodes.yml

# .PHONY: homelab-status
# homelab-status: ## Check the Kubernetes cluster
# 	@echo -e "$(OK_COLOR)[$(APP)] Check the cluster$(NO_COLOR)"
# 	@ansible-playbook -i inventory cluster.yml

.PHONY: homelab-salt-master
homelab-salt-master: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Configure Salt infra$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory salt-master.yml

.PHONY: homelab-salt-minions
homelab-salt-minions: ## Check hosts connection
	@echo -e "$(OK_COLOR)[$(APP)] Configure Salt infra$(NO_COLOR)"
	@cd $(ANSIBLE_DIR) && ansible-playbook -i inventory salt-minions.yml
