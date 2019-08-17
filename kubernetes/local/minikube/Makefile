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

MINIKUBE_VERSION = 1.2.0

SHELL = /bin/bash

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-30s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) / Local / Minikube ====$(NO_COLOR)"
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

.PHONY: local-minikube-check
local-minikube-check: ## Check requirements
	@if $$(hash curl 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) curl"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) curl"; \
	fi


# ====================================
# M I N I K U B E
# ====================================

.PHONY: local-minikube-deps
local-minikube-deps: ## Download development environment dependencies
	@echo -e "$(OK_COLOR)[$(APP)] Download minikube$(NO_COLOR)"
	@curl -sLo minikube https://storage.googleapis.com/minikube/releases/v$(MINIKUBE_VERSION)/minikube-linux-amd64 \
		&& chmod +x minikube

.PHONY: local-minikube-init
local-minikube-init: ## Initialize development environment
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster into Minikube$(NO_COLOR)"
	@./minikube --vm-driver=virtualbox start

.PHONY: local-minikube-destroy
local-minikube-destroy: ## Destroy the development environment
	@echo -e "$(OK_COLOR)[$(APP)] Delete Kubernetes cluster from Minikube$(NO_COLOR)"
	@./minikube delete
