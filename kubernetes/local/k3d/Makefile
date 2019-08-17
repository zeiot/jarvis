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

K3D_VERSION = 1.3.1
K3D_URI= https://github.com/rancher/k3d/releases/download/v$(K3D_VERSION)/k3d-linux-amd64

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
	@echo -e "$(OK_COLOR)==== $(APP) / Local / k3d ====$(NO_COLOR)"
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
# K U B E R N E T E S
# ====================================


.PHONY: local-k3d-check
local-k3d-check: ## Check requirements
	@if $$(hash k3d 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) k3d"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) k3d"; \
	fi

.PHONY: local-k3d-deps
local-k3d-deps: ## Download dependencies
	@echo -e "$(OK_COLOR)[$(APP)] Download dependencies$(NO_COLOR)"
	@wget $(K3D_URI) -O k3d \
		&& chmod +x ./k3d

.PHONY: local-k3d-create
local-k3d-create: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Create the cluster$(NO_COLOR)"
	@k3d create --name jarvis --workers 2

.PHONY: local-k3d-destroy
local-k3d-destroy: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Destroy the cluster$(NO_COLOR)"
	@k3d delete --name jarvis

.SILENT:
.PHONY: local-k3d-config
local-k3d-config: ## Generate kube-config file
	@k3d get-kubeconfig --name="jarvis"
