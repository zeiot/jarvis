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
user=$2
namespace=$3

echo "Kubernetes master: ${address}"

openssl genrsa -out ${username}.key 2048
openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${username}/O=jarvis"
openssl x509 -req -in ${username}.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out ${username}.crt

kubectl config set-cluster admin \
  --server=https://${address}:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true
kubectl config set-credentials ${username} \
  --client-certificate=${username}.crt
  --client-key=${username}.key  
  --embed-certs=true
kubectl config set-context ${username} \
  --cluster=admin \
  --namespace=${namespace} \
  --user=${username}
kubectl config use-context ${username}

cat ~/.kube/config >> /tmp/${user}-config
