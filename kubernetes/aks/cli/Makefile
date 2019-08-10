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

CLUSTER_NAME=jarvis-prod-azurecli
LOCATION=eastus
RESOURCE_GROUP=jarvis-group

K8S_VERSION = 1.11.5

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-35s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help


.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) / AKS / Azure CLI ====$(NO_COLOR)"
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

.PHONY: eks-eksctl-check
eks-eksctl-check: ## Check requirements
	@if $$(hash az 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) az"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) az"; \
	fi


# ====================================
# A Z U R E  C L I
# ====================================


.PHONY: aks-cli-kubernetes-create
aks-cli-kubernetes-create: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster$(NO_COLOR)"
	@az group create --name $(RESOURCE_GROUP) --location $(LOCATION)
	@az aks create --resource-group $RESOURCE_GROUP \
		--name $(CLUSTER_NAME) \
		--generate-ssh-keys \
		--kubernetes-version $(K8S_VERSION) \
		--enable-rbac \
		--node-vm-size Standard_DS3_v2

.PHONY: aks-cli-kubernetes-delete
aks-cli-kubernetes-delete: ## delete the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] delete Kubernetes cluster$(NO_COLOR)"

.PHONY: aks-cli-kubernetes-credentials
aks-cli-kubernetes-credentials:
	@echo -e "$(OK_COLOR)[$(APP)] Retrieve Kubernetes credentials$(NO_COLOR)"
	@az aks get-credentials --resource-group $(RESOURCE_GROUP) --name $(CLUSTER_NAME) --admin