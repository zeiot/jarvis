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

resource "openstack_compute_secgroup_v2" "jarvis-sg" {
  region      = "${var.openstack_region}"
  name        = "jarvis-sg"
  description = "Security group for the Kubernetes instances"

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    ip_protocol = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_network_v2" "jarvis-network" {
  region         = "${var.openstack_region}"
  name           = "jarvis-network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "jarvis-network" {
  name        = "jarvis-subnet"
  region      = "${var.openstack_region}"
  network_id  = "${openstack_networking_network_v2.jarvis-network.id}"
  cidr        = "${var.openstack_subnet_cidr_block}"
  ip_version  = 4
  enable_dhcp = "true"
}

resource "openstack_networking_router_v2" "jarvis-router" {
  name             = "jarvis-router"
  region           = "${var.openstack_region}"
  admin_state_up   = "true"
  # external_gateway = "${var.openstack_external_gateway}"
}

resource "openstack_networking_router_interface_v2" "jarvis-router-interface" {
  region    = "${var.openstack_region}"
  router_id = "${openstack_networking_router_v2.jarvis-router.id}"
  subnet_id = "${openstack_networking_subnet_v2.jarvis-router.id}"
}

resource "openstack_compute_floatingip_v2" "fip-master" {
  region = "${var.openstack_region}"
  pool   = "${var.openstack_floating_ip_pool_name}"
}
