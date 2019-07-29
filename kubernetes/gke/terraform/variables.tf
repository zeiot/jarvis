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

variable "env" {
  type = "string"
}

variable "name" {
  type    = "string"
  default = "jarvis-tf"
}

variable "project" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "europe-west1"
}

variable "kubernetes_version" {
  type    = "string"
  default = "1.12.8-gke.10"
}

variable "jarvis-gke-range" {
  type    = "string"
  default = "10.11.0.0/16"
}

variable "preemptible" {
  type    = "string"
  default = "true"
}

variable "min_node" {
  type    = "string"
  default = "4"
}

variable "max_node" {
  type    = "string"
  default = "7"
}

variable "secondary_range" {
  default = ""
}
