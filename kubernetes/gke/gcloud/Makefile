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

# CURRENT_PROJECT=$(gcloud info --format='value(config.project)')
PROJECT_NAME=jarvis-prod
PROJECT_ID=$(PROJECT_NAME)-1
CLUSTER_NAME=jarvis-prod-gcloud
GKE_SA=$(CLUSTER_NAME)-gke-sa
GKE_SA_EMAIL=$(GKE_SA)@$(PROJECT_ID).iam.gserviceaccount.com
K8S_VERSION=1.12.8-gke.10
NUM_NODES=3
MIN_NODES=2
MAX_NODES=4
REGION=europe-west1
ZONE=europe-west1-c
MACHINE_TYPE=n1-standard-1
# MACHINE_TYPE=f1-micro

KUBE_CONTEXT=gke_jarvis-prod-1_europe-west1-c_jarvis-prod-gcloud

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
	@echo -e "$(OK_COLOR)==== $(APP) / GKE / GCloud ====$(NO_COLOR)"
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

.PHONY: gke-gcloud-check
gke-gcloud-check: ## Check requirements
	@if $$(hash gcloud 2> /dev/null); then \
		echo -e "$(OK_COLOR)$(OK)$(NO_COLOR) gcloud"; \
	else \
		echo -e "$(ERROR_COLOR)$(KO)$(NO_COLOR) gcloud"; \
	fi


# ====================================
# G C L O U D
# ====================================

.SILENT:
.PHONY: gke-gcloud-kube-context
gke-gcloud-kube-context: ## Display Kubernetes context
	@echo $(KUBE_CONTEXT)

.PHONY: gke-gcloud-project-billing
gke-gcloud-project-billing: ## Display billing account
	@gcloud beta billing accounts list --quiet |grep -v "ACCOUNT_ID"|awk -F" " '{ print $1 }'

.PHONY: gke-gcloud-project-setup
gke-gcloud-project-setup: ## Setup GCloud project for Kubernetes
	@gcloud config set project ${PROJECT_ID}
	@gcloud config set compute/zone $(ZONE)
	@gcloud services enable iam.googleapis.com
	@gcloud services enable cloudresourcemanager.googleapis.com
	@gcloud services enable compute.googleapis.com
	@gcloud services enable container.googleapis.com
	@gcloud services enable containerregistry.googleapis.com
	@gcloud iam service-accounts create $(GKE_SA) --project $(PROJECT_ID) --display-name $(GKE_SA)
	@gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/storage.admin
	@gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/logging.logWriter
	@gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/monitoring.metricWriter
	@gcloud projects add-iam-policy-binding $(PROJECT_ID) --member serviceAccount:$(GKE_SA_EMAIL) --role roles/container.admin

.PHONY: gke-gcloud-project-create
gke-gcloud-project-create: guard-GCP_BILLING ## Create the GCloud project
	@echo -e "$(OK_COLOR)[$(APP)] Create GCloud project$(NO_COLOR)"
	@gcloud projects create $(PROJECT_ID) --name $(PROJECT_NAME)
	@gcloud beta billing projects link $(PROJECT_ID) --billing-account $(GCP_BILLING)

.PHONY: gke-gcloud-project-delete
gke-gcloud-project-delete: ## delete the GCloud project
	@echo -e "$(OK_COLOR)[$(APP)] Create GCloud project$(NO_COLOR)"
	@gcloud projects delete $(PROJECT_ID)

.PHONY: gke-gcloud-kubernetes-create
gke-gcloud-kubernetes-create: ## Create the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] Create Kubernetes cluster$(NO_COLOR)"
	@gcloud container clusters create \
		$(CLUSTER_NAME) --zone=${ZONE} --machine-type $(MACHINE_TYPE) \
		--preemptible --enable-autoscaling \
		--cluster-version=$(K8S_VERSION) \
		--image-type="COS" \
		--service-account $(GKE_SA_EMAIL) \
		--scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore \
		--num-nodes $(NUM_NODES) --min-nodes=$(MIN_NODES) --max-nodes=$(MAX_NODES)
	@kubectl create clusterrolebinding cluster-admin-binding \
		--clusterrole=cluster-admin \
		--user=$(gcloud config get-value core/account)

.PHONY: gke-gcloud-kubernetes-delete
gke-gcloud-kubernetes-delete: ## delete the Kubernetes cluster
	@echo -e "$(OK_COLOR)[$(APP)] delete Kubernetes cluster$(NO_COLOR)"
	@gcloud container clusters delete $(CLUSTER_NAME)

.PHONY: gke-gcloud-kubernetes-credentials
gke-gcloud-kubernetes-credentials:
	@echo -e "$(OK_COLOR)[$(APP)] Retrieve Kubernetes credentials$(NO_COLOR)"
	gcloud container clusters get-credentials $(CLUSTER_NAME) --zone=$(ZONE) --project $(PROJECT_ID)
