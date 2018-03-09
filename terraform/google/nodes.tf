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

resource "google_compute_instance" "jarvis-nodes" {
  count = "${var.nb_nodes}"
  zone = "${var.gce_zone}"
  name = "${var.cluster_name}-node-${count.index}" // => `xxx-node-{0,1,2}`
  description = "Kubernetes node ${count.index}"
  machine_type = "${var.gce_machine_type_node}"

  boot_disk {
    initialize_params {
      image = "${var.gce_image}"
      type  = "pd-ssd"
      size  = "200"
    }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file("${var.gce_ssh_public_key}")}"
  }
  network_interface {
    network = "${google_compute_network.jarvis-network.name}"
    access_config {
      // ephemeral ip
    }
  }
  connection {
    user = "${var.gce_ssh_user}"
    key_file = "${var.gce_ssh_private_key_file}"
    agent = false
  }

}
