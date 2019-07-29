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

APP = jarvis

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

MAKE_COLOR=\033[33;01m%-20s\033[0m

OK=[✅]
KO=[❌]
WARN=[⚠️]

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo -e "$(OK_COLOR)==== $(APP) [$(VERSION)] ====$(NO_COLOR)"
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

.PHONY: check
check: print-GOOGLE_APPLICATION_CREDENTIALS ## Check requirements
	@if $$(hash terraform 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) terraform"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) terraform"; \
	fi
	@if $$(hash kubectl 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) kubectl"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) kubectl"; \
	fi
	@if $$(hash kustomize 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) kustomize"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) kustomize"; \
	fi
	@if $$(hash conftest 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) conftest"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) conftest"; \
	fi


# ====================================
# T E R R A F O R M
# ====================================

tf-lint:
	@echo -e "$(OK_COLOR)[$(APP)] Lint Terraform lint$(NO_COLOR)"
	@terraform fmt -check=true -write=false -diff=true

terraform-lint: check-gcp-credentials tf-lint ## Lint Terraform and Skale-5 style

terraform-plan: guard-GOOGLE_APPLICATION_CREDENTIALS guard-CLOUD guard-ENV ## Plan Terraform (env=xxx)
	@echo -e "$(OK_COLOR)[$(CLOUD)] Validate Terraform configurations$(NO_COLOR)"
	@cd terraform/$(CLOUD) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform plan -var-file=tfvars/$(ENV).tfvars

terraform-apply: guard-GOOGLE_APPLICATION_CREDENTIALS guard-CLOUD guard-ENV ## Plan Terraform (env=xxx)
	@echo -e "$(OK_COLOR)[$(CLOUD)] Validate Terraform configurations$(NO_COLOR)"
	@cd kubernetes/$(CLOUD) \
		&& terraform init -reconfigure -backend-config=backend-vars/$(ENV).tfvars \
		&& terraform apply -var-file=tfvars/$(ENV).tfvars


# ====================================
# M I N I K U B E
# ====================================

.PHONY: minikube-deps
minikube-deps: ## Download development environment dependencies
	@echo -e "$(OK_COLOR)[$(APP)] Download minikube$(NO_COLOR)"
	@curl -sLo minikube https://storage.googleapis.com/minikube/releases/v$(MINIKUBE_VERSION)/minikube-linux-amd64 \
		&& chmod +x minikube

.PHONY: minikube-init
minikube-init: ## Initialize development environment
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster into Minikube$(NO_COLOR)"
	./minikube --vm-driver=virtualbox start

.PHONY: minikube-destroy
minikube-destroy: ## Destroy the development environment
	@echo -e "$(OK_COLOR)[$(APP)] Delete Kubernetes cluster from Minikube$(NO_COLOR)"
	./minikube delete


# ====================================
# K U B E R N E T E S
# ====================================


.PHONY: kubernetes-deps
kubernetes-deps: ## Retrieve Kubernetes dependencies
	@echo -e "$(OK_COLOR)[$(APP)] Download kubectl$(NO_COLOR)"
	@curl -sLo kubectl http://storage.googleapis.com/kubernetes-release/release/v$(KUBECTL_VERSION)/bin/linux/amd64/kubectl \
		&& chmod +x kubectl
	@echo -e "$(OK_COLOR)[$(APP)] Download kustomize$(NO_COLOR)"
	@curl -sLo kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/v$(KUSTOMIZE_VERSION)/kustomize_$(KUSTOMIZE_VERSION)_linux_amd64 \
		&& chmod +x kustomize

kubernetes-check-context:
	@if [[ "${KUBE_CONTEXT}" != "${KUBE_CURRENT_CONTEXT}" ]] ; then \
		echo -e "$(ERROR_COLOR)[KO]$(NO_COLOR) Kubernetes context: ${KUBE_CONTEXT} vs ${KUBE_CURRENT_CONTEXT}"; \
		exit 1; \
	fi

.PHONY: kubernetes-switch-context ## Switch on the Kubernetes context
kubernetes-switch-context:
	@kubectl config use-context $(KUBE_CONTEXT)

.PHONY: kubernetes-check
kubernetes-check: guard-SERVICE guard-ENV ## Check Kubernetes manifests using policies
	@echo -e "$(OK_COLOR)[$(APP)] Check Kubernetes manifests$(NO_COLOR)"
	@kustomize build $(SERVICE)/overlays/$(ENV)| conftest test -p kubernetes/policy -

.PHONY: kubernetes-build
kubernetes-build: guard-SERVICE guard-ENV ## Build Kustomization (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Build kustomization$(NO_COLOR)"
	kustomize build $(SERVICE)/overlays/$(ENV)

kubernetes-apply: guard-SERVICE guard-ENV kubernetes-check-context ## Apply Kustomization (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Build kustomization$(NO_COLOR)"
	kustomize build $(SERVICE)/overlays/$(ENV)|kubectl apply -f -

kubernetes-delete: guard-SERVICE guard-ENV kubernetes-check-context ## Delete Kustomization (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Build kustomization$(NO_COLOR)"
	kustomize build $(SERVICE)/overlays/$(ENV)|kubectl delete -f -
