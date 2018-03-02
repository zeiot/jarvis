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

if [ $# -ne 1 ]; then
    echo "Usage: $0 <master ip>"
    exit 1
fi

address=$1
echo "Kubernetes master: ${address}"
kubectl config set-cluster admin \
  --server=https://$address:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true
kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt \
  --client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key \
  --embed-certs=true
kubectl config set-context admin \
  --cluster=admin \
  --user=admin
kubectl config use-context admin

cat ~/.kube/config >> /tmp/config
