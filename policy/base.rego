# Copyright (C) 2016, 2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

#
# Open Policy Agent rules
#

package main

name = input.metadata.name

hasKubeLabels {
	input.metadata.labels["app.kubernetes.io/name"]
  input.metadata.labels["app.kubernetes.io/instance"]
  input.metadata.labels["app.kubernetes.io/version"]
  input.metadata.labels["app.kubernetes.io/component"]
  input.metadata.labels["app.kubernetes.io/part-of"]
  input.metadata.labels["app.kubernetes.io/managed-by"]
}

deny[msg] {
  not hasKubeLabels
  msg = sprintf("%s must include Kubernetes recommended labels: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/#labels ", [name])
}

