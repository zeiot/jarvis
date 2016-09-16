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
wifipassword=$3
host=$4

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"
DEBUG_COLOR="\033[34;01m"

HYPRIOTOS_VERSION=1.0.0

echo -e "${OK_COLOR}== Jarvis OS: Hypriot ${HYPRIOTOS_VERSION} ==${NO_COLOR}"
if [ $# -ne 4 ]; then
  echo -e "${ERROR_COLOR}Usage: $0 hostname ssid wifipassword Linux|Darwin${NO_COLOR}"
  exit 1
fi

echo -e "${DEBUG_COLOR}Download flash${NO_COLOR}"
curl -LO --progress-bar https://raw.githubusercontent.com/hypriot/flash/master/${host}/flash
chmod +x flash
./flash --hostname ${hostname} --ssid ${ssid} --password ${wifipassword} https://downloads.hypriot.com/hypriotos-rpi-v${HYPRIOTOS_VERSION}.img.zip

echo -e "${DEBUG_COLOR}Cleanup${NO_COLOR}"
rm ./flash

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
