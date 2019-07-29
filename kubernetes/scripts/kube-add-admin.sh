#!/bin/bash

# Copyright (C) 2016, 2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/commons.sh
. ${SCRIPTPATH}/certs.sh


if [ $# -ne 2 ]; then
    echo -e "${ERROR_COLOR}Usage: $0 <master ip> <username>${NO_COLOR}"
    exit 1
fi

address=$1
username=$2
cluster_name="kube-jarvis"

echo -e "${INFO_COLOR}Kubernetes master: ${address}${NO_COLOR}"

generate_certs ${username}

KUBECONFIG=/tmp/${username}-config

KUBECONFIG=${KUBECONFIG} kubectl config set-cluster ${cluster_name} \
  --server=https://${address}:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true

KUBECONFIG=${KUBECONFIG} kubectl config set-credentials ${username} \
  --client-certificate=/tmp/${username}.crt \
  --client-key=/tmp/${username}.key \
  --embed-certs=true

KUBECONFIG=${KUBECONFIG} kubectl config set-context ${username} \
  --cluster=${cluster_name} \
  --user=${username}

KUBECONFIG=${KUBECONFIG} kubectl config use-context ${username}

kubectl create clusterrolebinding ${username}-cluster-admin-binding --clusterrole=cluster-admin --user=${username}