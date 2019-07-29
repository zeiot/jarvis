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

VERSION = 0.3.0

MINIKUBE_VERSION = 1.2.0
KUBECTL_VERSION = 1.15.0
KUSTOMIZE_VERSION = 3.0.0

KUBE_CONTEXT=kube-jarvis
KUBE_CURRENT_CONTEXT=$(shell kubectl config current-context)

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
	@echo -e "$(OK_COLOR)==== $(APP) / GKE / Terraform ====$(NO_COLOR)"
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

.PHONY: gke-terraform-check
gke-terraform-check: print-GOOGLE_APPLICATION_CREDENTIALS ## Check requirements
	@if $$(hash terraform 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) terraform"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) terraform"; \
	fi

# ====================================
# T E R R A F O R M
# ====================================

tf-lint:
	@echo -e "$(OK_COLOR)[$(APP)] Lint Terraform lint$(NO_COLOR)"
	@terraform fmt -check=true -write=false -diff=true

gke-terraform-lint: check-gcp-credentials tf-lint ## Lint Terraform and Skale-5 style

.PHONY: gke-terraform-plan
gke-terraform-plan: guard-GOOGLE_APPLICATION_CREDENTIALS guard-CLOUD guard-ENV ## Plan Terraform (env=xxx)
	@echo -e "$(OK_COLOR)[$(CLOUD)] Validate Terraform configurations$(NO_COLOR)"
	@cd terraform/$(CLOUD) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform plan -var-file=tfvars/$(ENV).tfvars

.PHONY: gke-terraform-apply
gke-terraform-apply: guard-GOOGLE_APPLICATION_CREDENTIALS guard-CLOUD guard-ENV ## Plan Terraform (env=xxx)
	@echo -e "$(OK_COLOR)[$(CLOUD)] Validate Terraform configurations$(NO_COLOR)"
	@cd kubernetes/$(CLOUD) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform apply -var-file=tfvars/$(ENV).tfvars
