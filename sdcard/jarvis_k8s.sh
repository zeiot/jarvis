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

K8S_ARM_VERSION=0.8.0

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"
DEBUG_COLOR="\033[34;01m"

echo -e "${OK_COLOR}== Jarvis Kubernetes ${K8S_ARM_VERSION}==${NO_COLOR}"
if [ $# -ne 4 ]; then
  echo -e "${ERROR_COLOR}Usage: $0 hostname ssid wifipassword rpi-2|rpi-3${NO_COLOR}"
  exit 1
fi

echo -e "${DEBUG_COLOR}Download kubernetes-on-arm${NO_COLOR}"
curl -LO --progress-bar https://github.com/luxas/kubernetes-on-arm/releases/download/v${K8S_ARM_VERSION}/docker-multinode.deb
sudo dpkg -i docker-multinode.deb

echo -e "${DEBUG_COLOR}Cleanup${NO_COLOR}"
rm docker-multinode.deb

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
