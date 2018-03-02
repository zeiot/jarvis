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

SCRIPT=$(readlink -f "$0")
# echo $SCRIPT
SCRIPTPATH=$(dirname "$SCRIPT")
# echo $SCRIPTPATH

. ${SCRIPTPATH}/commons.sh
. ${SCRIPTPATH}/certs.sh



function usage {
    echo -e "${OK_COLOR}Usage${NO_COLOR} : $0 -s <master ip> -u <username> [ -n <namespace> ]"
}

address=""
username=""
namespace=""

while getopts s:u:n:h option; do
    case "${option}"
    in
        s) address=${OPTARG};;
        u) username=${OPTARG};;
        n) namespace=${OPTARG};;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# DEBUG
# echo "Kubernetes: ${address}"
# echo "Username: ${username}"
# echo "Namespace: ${namespace}"
# exit 0

if [ -z "${address}" ]; then
    usage
    exit 1
fi
if [ -z "${username}" ]; then
    usage
    exit 1
fi

echo -e "${INFO_COLOR}Kubernetes master: ${address}${NO_COLOR}"

generate_certs ${username}

KUBECONFIG=/tmp/${username}-config

KUBECONFIG=${KUBECONFIG} kubectl config set-cluster admin \
  --server=https://${address}:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true

KUBECONFIG=${KUBECONFIG} kubectl config set-credentials ${username} \
          --client-certificate=/tmp/${username}.crt \
          --client-key=/tmp/${username}.key \
          --embed-certs=true

if [ -n "${namespace}" ]; then
    KUBECONFIG=${KUBECONFIG} kubectl config set-context ${username} \
              --cluster=admin \
              --namespace=${namespace} \
              --user=${username}
fi

KUBECONFIG=${KUBECONFIG} kubectl config use-context ${username}
