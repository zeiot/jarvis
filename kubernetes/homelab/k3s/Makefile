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

KUBE_CONTEXT=kube-jarvis

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-25s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) / Homelab / k3s ====$(NO_COLOR)"
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
# K 3 S U P
# ====================================

.PHONY: homelab-k3s-k3sup-install
homelab-k3s-k3sup-install: guard-SERVER_IP guard-USER ## Create the server
	@echo -e "$(OK_COLOR)[$(APP)] K3sup install$(NO_COLOR)"
	@k3sup install --ip $(SERVER_IP) --user $(USER) --k3s-extra-args '--no-deploy servicelb'


.PHONY: homelab-k3s-k3sup-join
homelab-k3s-k3sup-join: guard-SERVER_IP guard-USER guard-NODE_IP ## Join node
	@echo -e "$(OK_COLOR)[$(APP)] K3sup join node$(NO_COLOR)"
	k3sup join --ip $(NODE_IP) --server-ip $(SERVER_IP) --user $(USER)


# ====================================
# A N S I B L E
# ====================================


.PHONY: homelab-k3s-check
homelab-k3s-check: ## Check requirements
	@if $$(hash k3s 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) k3s"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) k3s"; \
	fi

.PHONY: homelab-k3s-ping
homelab-k3s-ping: ## Ping hosts
	@echo -e "$(OK_COLOR)[$(APP)] Check hosts$(NO_COLOR)"
	@ansible all -m ping -i ansible/inventory

.PHONY: homelab-k3s-users
homelab-k3s-users: ## Add user
	@echo -e "$(OK_COLOR)[$(APP)] Add user$(NO_COLOR)"
	@ansible-playbook -i ansible/inventory ansible/users.yml


.PHONY: homelab-k3s-debug
homelab-k3s-debug: ## Display debug informations
	@echo -e "$(OK_COLOR)[$(APP)] Debug informations $(NO_COLOR)"
	@ansible-playbook -i ansible/inventory ansible/debug.yml

.PHONY: homelab-k3s-create
homelab-k3s-create: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Create the cluster$(NO_COLOR)"
	@ansible-playbook -i ansible/inventory ansible/k3s.yml

.PHONY: homelab-k3s-destroy
homelab-k3s-destroy: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Destroy the cluster$(NO_COLOR)"
	@ansible-playbook -i ansible/inventory ansible/destroy.yml