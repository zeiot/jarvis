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

CLUSTER_NAME=jarvis-prod-eksctl
REGION=eu-west-3

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
	@echo -e "$(OK_COLOR)==== $(APP) / EKS / Eksctl ====$(NO_COLOR)"
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
	@if $$(hash eksctl 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) eksctl"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) eksctl"; \
	fi
	@if $$(hash aws-iam-authenticator 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) aws-iam-authenticator"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) aws-iam-authenticator"; \
	fi

.PHONY: eks-eksctl-deps
eks-eksctl-deps: ## Download dependencies
	@echo -e "$(OK_COLOR)[$(APP)] Download dependencis$(NO_COLOR)"
	@curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator \
		&& chmod +x aws-iam-authenticator


# ====================================
# E K S C T L
# ====================================

.PHONY: eks-eksctl-kubernetes-create
eks-eksctl-kubernetes-create: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster$(NO_COLOR)"
	@eksctl create cluster -f cluster.yaml

.PHONY: eks-eksctl-kubernetes-delete
eks-eksctl-kubernetes-delete: ## delete the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] delete Kubernetes cluster$(NO_COLOR)"
	@eksctl delete cluster --name $(CLUSTER_NAME) --region $(REGION)

