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

env = "prd"

project = "jarvis-prd-tf"

kubernetes_version = "1.12.6-gke.7"

jarvis-gke-range = "10.12.0.0/16"

preemptible = "false"

secondary_range = "jarvis-gke-services-prd-subnet-europe-west1"

min_node = 4

max_node = 6
