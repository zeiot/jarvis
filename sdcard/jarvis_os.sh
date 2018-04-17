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

HYPRIOTOS_VERSION=1.8.0

hostname=""
ssid=""
wifipassword=""


function usage {
    echo -e "${OK_COLOR}Usage${NO_COLOR} : $0 --hostname <hostname> --ssid <ssid> --password <wifipassword>"
}

function create {
    local hostname=$1
    local ssid=$2
    local wifipassword=$3
    echo -e "${OK_COLOR}== Jarvis OS: Hypriot ${HYPRIOTOS_VERSION} ==${NO_COLOR}"
    echo -e "${DEBUG_COLOR}Download flash${NO_COLOR}"
    curl -sSLO --progress-bar https://raw.githubusercontent.com/hypriot/flash/2.0.0/flash
    chmod +x flash
    echo -e "${DEBUG_COLOR}Flash HypriotOS${NO_COLOR}"
    ./flash --hostname ${hostname} --ssid ${ssid} --password ${wifipassword} https://github.com/hypriot/image-builder-rpi/releases/download/v${HYPRIOTOS_VERSION}/hypriotos-rpi-v${HYPRIOTOS_VERSION}.img.zip
    echo -e "${DEBUG_COLOR}Cleanup${NO_COLOR}"
    rm ./flash
    echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
}

if [ $# -eq 0 ]; then
    usage
    exit 0
fi

while getopts n:s:p:h option; do
    case "${option}"
    in
        n) hostname=${OPTARG};;
        s) ssid=${OPTARG};;
        p) wifipassword=${OPTARG};;
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

# DEBUG:
# echo ${hostname}
# echo ${ssid}
# echo ${wifipassword}
# exit 0

create ${hostname} ${ssid} ${wifipassword}
