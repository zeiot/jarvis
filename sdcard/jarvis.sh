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

hostname=$1
ssid=$2
wifipasswd=$3
rpi=$4

K8S_ARM_VERSION=0.7.0

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"
DEBUG_COLOR="\033[34;01m"

echo -e "${OK_COLOR}== Jarvis for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -ne 4 ]; then
  echo -e "${ERROR_COLOR}Usage: $0 hostname ssid wifipassword rpi-2|rpi-3${NO_COLOR}"
  exit 1
fi

echo -e "${DEBUG_COLOR}Download kubernetes-on-arm${NO_COLOR}"

# git clone https://github.com/luxas/kubernetes-on-arm
curl -LO --progress-bar https://github.com/luxas/kubernetes-on-arm/archive/v${K8S_ARM_VERSION}.tar.gz
tar zxvf v${K8S_ARM_VERSION}.tar.gz
cd kubernetes-on-arm-${K8S_ARM_VERSION}

echo -e "${DEBUG_COLOR}Install kubernetes${NO_COLOR}"
# Display help:
# sdcard/write.sh
# sdcard/write.sh /dev/sdb ${rpi} hypriotos kube-systemd

echo -e "${DEBUG_COLOR}Cleanup${NO_COLOR}"
cd ..
rm -r kubernetes-on-arm-${K8S_ARM_VERSION}
rm v${K8S_ARM_VERSION}.tar.gz

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
