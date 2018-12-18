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

APP="Jarvis / Cloud"

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

MAKE_COLOR=\033[33;01m%-20s\033[0m

SHELL = /bin/bash

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) ====$(NO_COLOR)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(MAKE_COLOR) : %s\n", $$1, $$2}'

.PHONY: init
init: ## Create Jarvis on GKE
	@echo -e "$(OK_COLOR)[$(APP)] Initialize Cloud Providers$(NO_COLOR)"
	cd gke/ && terraform init -upgrade
	cd aks && terraform init -upgrade

# ------------------------------- KGE ---------------------------------------

.PHONY: create-gke
create-gke: ## Create Jarvis on GKE
	@echo -e "$(OK_COLOR)[$(APP)] Create Jarvis Kubernetes cluster on GKE$(NO_COLOR)"
	@cd gke && terraform apply

.PHONY: destroy-gke
destroy-gke: ## Destroy Jarvis on GKE
	@echo -e "$(OK_COLOR)[$(APP)] Destroy Jarvis Kubernetes cluster from GKE$(NO_COLOR)"
	@cd gke && terraform destroy
