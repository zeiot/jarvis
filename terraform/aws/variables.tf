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

variable "aws_access_key" {
  description = "AWS access key."
}

variable "aws_secret_key" {
    description = "AWS secret key."
}

variable "aws_region" {
    description = "AWS region."
    default = "eu-west-1"
}

variable "aws_key_name" {
    description = "The SSH key name to use for the instances."
}

variable "aws_ssh_public_key" {
  description = "Path to the SSH public key."
}

variable "aws_ssh_private_key_file" {
    description = "Path to the SSH private key file."
}

variable "aws_ssh_user" {
    description = "SSH user."
    default = "ubuntu"
}

variable "aws_vpc_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "10.0.0.0/16"
}

variable "aws_subnet_cidr_block" {
    description = "The IPv4 address range that machines in the network are assigned to, represented as a CIDR block."
    default = "10.0.1.0/24"
}

variable "aws_image" {
    description = "The name of the image to base the launched instances."
}

variable "aws_instance_type_master" {
    description = "The machine type to use for the master instance."
    default = "m3.medium"
}

variable "aws_instance_type_node" {
    description = "The machine type to use for the nodes instances."
    default = "m3.medium"
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
