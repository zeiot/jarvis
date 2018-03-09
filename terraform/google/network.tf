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

resource "google_compute_network" "jarvis-network" {
  name                    = "${var.cluster_name}"
  auto_create_subnetworks = false
}


# // Create a subnet for the cluster in the region that we are running in.
# resource "google_compute_subnetwork" "subnet" {
#   name          = "${var.cluster_name}-default-${var.region}"
#   ip_cidr_range = "${module.subnets.host_cidr}"
#   network       = "${google_compute_network.network.name}"
# }

# Firewall
resource "google_compute_firewall" "jarvis-firewall-external" {
  name          = "jarvis-firewall-external"
  network       = "${google_compute_network.jarvis-network.name}"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "22",   # SSH
      "80",   # HTTP
      "443",  # HTTPS
      "6443", # Kubernetes secured server
      "8080", # Kubernetes unsecure server
    ]
  }

}

resource "google_compute_firewall" "jarvis-firewall-internal" {
  name = "jarvis-firewall-internal"
  network = "${google_compute_network.jarvis-network.name}"
  # source_ranges = ["${google_compute_network.jarvis-network.ipv4_range}"]

  allow {
    protocol = "tcp"
    ports = ["1-65535"]
  }

  allow {
    protocol = "udp"
    ports = ["1-65535"]
  }

  source_ranges = ["${var.gce_cidr}"]
}
