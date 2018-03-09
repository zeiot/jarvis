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

resource "aws_vpc" "jarvis-network" {
  cidr_block = "${var.aws_vpc_cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "jarvis"
  }
}

resource "aws_subnet" "jarvis-network" {
  vpc_id = "${aws_vpc.jarvis-network.id}"
  cidr_block = "${var.aws_subnet_cidr_block}"
  map_public_ip_on_launch = true
  tags {
    Name = "jarvis"
  }
}

resource "aws_internet_gateway" "jarvis-network" {
  vpc_id = "${aws_vpc.jarvis-network.id}"
}

resource "aws_route_table" "jarvis-network" {
  vpc_id = "${aws_vpc.jarvis-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.jarvis-network.id}"
  }
}

resource "aws_route_table_association" "jarvis-network" {
  subnet_id = "${aws_subnet.jarvis-network.id}"
  route_table_id = "${aws_route_table.jarvis-network.id}"
}

resource "aws_security_group" "jarvis-network" {
  name = "jarvis"
  description = "Jarvis security group"
  vpc_id = "${aws_vpc.jarvis-network.id}"
  ingress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "tcp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol = "udp"
    from_port = 1
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "jarvis"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.jarvis-master.id}"
  vpc = true
  connection {
    # host = "${aws_eip.ip.public_ip}"
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }
}
