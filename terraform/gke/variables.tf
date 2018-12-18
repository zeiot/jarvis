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

variable "gcp_region" {
  description = "GCP region"
  default = "europe-west1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. europe-west1-b (which must be in gcp_region)"
  default = "europe-west1-b"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "cluster_name" {
  description = "Name of the K8s cluster"
  default = "jarvis"
}

variable "initial_node_count" {
  description = "Number of worker VMs to initially create"
  default = 2
}

variable "master_username" {
  description = "Username for accessing the Kubernetes master endpoint"
  default = "k8smaster"
}

variable "master_password" {
  description = "Password for accessing the Kubernetes master endpoint"
  default = "k8smasterk8smaster"
}

variable "node_machine_type" {
  description = "GCE machine type"
  default = "n1-standard-2"
}

variable "node_disk_size" {
  description = "Node disk size in GB"
  default = "20"
}

# variable "environment" {
#   description = "value passed to Environment tag"
#   default = "dev"
# }

# variable "vault_user" {
#   description = "Vault userid: determines location of secrets and affects path of k8s auth backend"
# }

# variable "vault_addr" {
#   description = "Address of Vault server including port"
# }
