# Copyright (C) 2017-2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

variable "gce_credentials" {
  description = "Path to the JSON file used to describe your account credentials, downloaded from Google Cloud Console."
}

variable "gce_project" {
  description = "The name of the project to apply any resources to."
}

variable "gce_ssh_user" {
  description = "SSH user."
}

variable "gce_ssh_public_key" {
  description = "Path to the ssh key to use"
}

variable "gce_ssh_private_key_file" {
  description = "Path to the SSH private key file."
}

variable "gce_region" {
  description = "The region to operate under."
  default = "europe-west1"
}

variable "gce_zone" {
  description = "The zone that the machines should be created in."
  default = "europe-west1-b"
}

variable "gce_cidr" {
  default = "10.20.0.0/16"
}

variable "gce_image" {
  description = "The name of the image to base the launched instances."
}

variable "gce_machine_type_master" {
  description = "The machine type to use for the jarvis master."
  default = "n1-standard-1"
}

variable "gce_machine_type_node" {
  description = "The machine type to use for the jarvis nodes."
  default = "n1-standard-1"
}

variable "kubeadm_token" {
  description = "The Kubeadm token for initialize the cluster."
}

variable "nb_nodes" {
  description = "The number of nodes."
  default = "2"
}

variable "cluster_name" {
  default = "jarvis"
}
