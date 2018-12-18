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

provider "google" {
    version = ">= 1.18.0"
#   credentials = "${data.vault_generic_secret.gcp_credentials.data[var.gcp_project]}"
    project     = "${var.gcp_project}"
    region      = "${var.gcp_region}"
}

# resource "google_container_cluster" "k8sexample" {
#   name                    = "${var.cluster_name}"
#   description             = "example k8s cluster"
#   zone                    = "${var.gcp_zone}"
#   initial_node_count      = "${var.initial_node_count}"
#   enable_kubernetes_alpha = "true"
#   enable_legacy_abac      = "true"

#   master_auth {
#     username = "${var.master_username}"
#     password = "${var.master_password}"
#   }

#   node_config {
#     machine_type = "${var.node_machine_type}"
#     disk_size_gb = "${var.node_disk_size}"
#     oauth_scopes = [
#       "https://www.googleapis.com/auth/compute",
#       "https://www.googleapis.com/auth/devstorage.read_only",
#       "https://www.googleapis.com/auth/logging.write",
#       "https://www.googleapis.com/auth/monitoring"
#     ]
#   }
# }

# resource "null_resource" "auth_config" {
#   provisioner "local-exec" {
#     command = "curl --header \"X-Vault-Token: $VAULT_TOKEN\" --header \"Content-Type: application/json\" --request POST --data '{ \"kubernetes_host\": \"https://${google_container_cluster.k8sexample.endpoint}:443\", \"kubernetes_ca_cert\": \"${chomp(replace(base64decode(google_container_cluster.k8sexample.master_auth.0.cluster_ca_certificate), "\n", "\\n"))}\" }' ${var.vault_addr}/v1/auth/${vault_auth_backend.k8s.path}config"
#   }
# }

# resource "vault_generic_secret" "role" {
#   path = "auth/${vault_auth_backend.k8s.path}role/demo"
#   data_json = <<EOT
#   {
#     "bound_service_account_names": "cats-and-dogs",
#     "bound_service_account_namespaces": "default",
#     "policies": "${var.vault_user}",
#     "ttl": "24h"
#   }
#   EOT
# }