#!/bin/bash

# Copyright (C) 2016-2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

if [ $# -ne 3 ]; then
    echo "Usage: $0 <master ip> <username> <namespace>"
    exit 1
fi

address=$1
username=$2
namespace=$3

echo "Kubernetes master: ${address}"

openssl genrsa -out /tmp/${username}.key 2048
openssl req -new -key /tmp/${username}.key -out /tmp/${username}.csr -subj "/CN=${username}/O=jarvis"
sudo openssl x509 -req -in /tmp/${username}.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/${username}.crt

KUBECONFIG=/tmp/${username}-config

KUBECONFIG=${KUBECONFIG} kubectl config set-cluster admin \
  --server=https://${address}:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true
KUBECONFIG=${KUBECONFIG} kubectl config set-credentials ${username} \
  --client-certificate=/tmp/${username}.crt \
  --client-key=/tmp/${username}.key \
  --embed-certs=true
KUBECONFIG=${KUBECONFIG} kubectl config set-context ${username} \
  --cluster=admin \
  --namespace=${namespace} \
  --user=${username}

KUBECONFIG=${KUBECONFIG} kubectl config use-context ${username}

