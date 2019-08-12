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

KUBECTL_VERSION = 1.15.0
KUSTOMIZE_VERSION = 3.0.0

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
# G K E
# ====================================

gke-kube-%:
	@cd "kubernetes/gke/$*" && make help

.SILENT:
gke-%: guard-SETUP ## GKE setup
	@echo -e "$(OK_COLOR)[$(APP)] GKE setup using $(SETUP)$(NO_COLOR)"
	@cd "kubernetes/gke/$(SETUP)" && make $@

.PHONY: help-gke
help-gke: gke-kube-gcloud gke-kube-terraform ## Help for GKE
	@echo -e "$(NO_COLOR) > Usage: make gke-.... SETUP=xxx $(NO_COLOR)"


# ====================================
# E K S
# ====================================

eks-kube-%:
	@cd "kubernetes/eks/$*" && make help

.SILENT:
eks-%: guard-SETUP ## EKS setup
	@echo -e "$(OK_COLOR)[$(APP)] EKS setup using $(SETUP)$(NO_COLOR)"
	@cd "kubernetes/eks/$(SETUP)" && make $@

.PHONY: help-eks
help-eks: eks-kube-eksctl ## Help for EKS
	@echo -e "$(NO_COLOR) > Usage: make eks-.... SETUP=xxx $(NO_COLOR)"



# ====================================
# A K S
# ====================================

aks-kube-%:
	@cd "kubernetes/aks/$*" && make help

.SILENT:
aks-%: guard-SETUP ## AKS setup
	@echo -e "$(OK_COLOR)[$(APP)] AKS setup using $(SETUP)$(NO_COLOR)"
	@cd "kubernetes/aks/$(SETUP)" && make $@

.PHONY: help-aks
help-aks: aks-kube-cli ## Help for EKS
	@echo -e "$(NO_COLOR) > Usage: make aks-.... SETUP=xxx $(NO_COLOR)"




# ====================================
# L O C A L
# ====================================

.PHONY: help-local
help-local: local-kube-minikube ## Help for local
	@echo -e "$(WARN_COLOR)[$(CLOUD)] Usage: make local-.... SETUP=xxx $(NO_COLOR)"

local-kube-%:
	@cd "kubernetes/local/$*" && make help

local-%: ## Local setup
	@echo -e "$(OK_COLOR)[$(APP)] Local setup using $(SETUP)$(NO_COLOR)"
	@cd "kubernetes/local/$(SETUP)" && make $@


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

kubernetes-apply: guard-SERVICE guard-ENV guard-KUBE_CONTEXT kubernetes-check-context ## Apply Kustomization (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Build kustomization$(NO_COLOR)"
	kustomize build $(SERVICE)/overlays/$(ENV)|kubectl apply -f -

kubernetes-delete: guard-SERVICE guard-ENV guard-KUBE_CONTEXT kubernetes-check-context ## Delete Kustomization (SERVICE=xxx ENV=xxx)
	@echo -e "$(OK_COLOR)[$(APP)] Build kustomization$(NO_COLOR)"
	kustomize build $(SERVICE)/overlays/$(ENV)|kubectl delete -f -
