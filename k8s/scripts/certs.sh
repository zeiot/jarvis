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



function generate_certs {
    local username="$1"
    echo -e "${OK_COLOR}Generate PKI for user: ${username}${NO_COLOR}"
    openssl genrsa -out /tmp/${username}.key 2048
    openssl req -new -key /tmp/${username}.key -out /tmp/${username}.csr -subj "/CN=${username}/O=jarvis"
    sudo openssl x509 -req -in /tmp/${username}.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/${username}.crt

}
