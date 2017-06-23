#!/bin/bash

# Copyright (C) 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"
DEBUG_COLOR="\033[34;01m"

K8S_VERSION="v1.4.4"

if [ $# -eq 0 ]; then
    echo -e "${ERROR_COLOR}Usage: $0 <MASTER_IP>${NO_COLOR}"
    exit 1
fi
K8S_MASTER_IP=$1

echo -e "${OK_COLOR}== Jarvis Kubernetes ${K8S_ARM_VERSION}==${NO_COLOR}"

echo -e "${OK_COLOR}== Setup Kubernetes ==${NO_COLOR}"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get -y kubelet kubeadm kubectl kubernetes-cni

echo -e "${OK_COLOR} == Start Kubelet ==${NO_COLOR}"
sudo systemctl enable kubelet && sudo systemctl start kubelet

echo -e "${OK_COLOR} == Initiliaze master ==${NO_COLOR}"
kubeadm init --use-kubernetes-version ${K8S_VERSION} --api-advertise-addresses=${K8S_MASTER_IP} --pod-network-cidr=10.244.0.0/16

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
