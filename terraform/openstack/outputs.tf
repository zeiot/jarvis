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

output "master_public_ip" {
  value = "${openstack_compute_floatingip_v2.jarvis-fip-master.address}"
}

output "username" {
  value = "${var.openstack_ssh_user}"
}

output "token" {
  value = "${var.kubeadm_token}"
}

output "node_private_ip" {
  value = ["${openstack_compute_instance_v2.jarvis-nodes.*.network.0.fixed_ip_v4}"]
}
