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

. commons.sh

hypriot_version="1.0.0"
hypriot_img="v${hypriot_version}"

hostname=$1
ssid=$2
wifipasswd=$3

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"


function get_os {
    case "$OSTYPE" in
        darwin*)  echo "Darwin" ;;
        linux*)   echo "Linux" ;;
        *)        echo "unknown: $OSTYPE" ;;
    esac
}

echo -e "${OK_COLOR}== Hypriot ${hypriot_version} for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -ne 3 ]; then
  echo -e "${ERROR_COLOR}Usage: $0 hostname ssid wifipassword${NO_COLOR}"
  exit 1
fi

if [ ! -f "flash" ]; then
    os=$(get_os)
    curl -LO  --progress-bar https://raw.githubusercontent.com/hypriot/flash/master/${os}/flash
    chmod +x ./flash
fi

echo -e "${OK_COLOR}== Install HypriotOS ${hypriot_version} ==${NO_COLOR}"
./flash https://downloads.hypriot.com/hypriotos-rpi-v${hypriot_version}.img.zip

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
