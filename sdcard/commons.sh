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


NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"


function display_usage() {
    echo -e "${ERROR_COLOR}Usage: $0 <device> ${NO_COLOR}"
    echo -e "With device:"
    echo -e "  sdb for Linux"
    echo -e "  rdisk1 for OSX"
    exit 1
}

function get_os {
    case "$OSTYPE" in
        solaris*) echo "SOLARIS" ;;
        darwin*)  echo "OSX" ;;
        linux*)   echo "LINUX" ;;
        bsd*)     echo "BSD" ;;
        *)        echo "unknown: $OSTYPE" ;;
    esac
}


function get_sdcard {
    device=$1
    os=$2
    sdcard=""
    case "${os}" in
    "OSX")
        sdcard="/dev/${device}"
        ;;
    "LINUX")
        sdcard="/dev/${device}"
        ;;
    *)
        echo -e "${ERROR_COLOR}Operating system not supported: ${os}${NO_COLOR}"
        exit 1
        ;;
    esac
    echo ${sdcard}
}

function setup_sdcard {
    sdcard=$1
    os=$2
    case "${os}" in
    "OSX")
        echo -e "${WARN_COLOR}Unmounting${NO_COLOR}"
        sudo diskutil unmountDisk ${sdcard}

        echo -e "${WARN_COLOR}Setup SD Card${NO_COLOR}"
        sudo dd if=/dev/zero of=${sdcard} bs=1024 count=1
        ;;
    "LINUX")
        echo -e "${WARN_COLOR}Setup SD Card${NO_COLOR}"
        parted -s ${sdcard} unit s print
        parted ${sdcard} mkpart primary fat32 0 100%

        echo -e "${WARN_COLOR}Unmounting${NO_COLOR}"
        umount ${sdcard}1
        ;;
    *)
        echo -e "${ERROR_COLOR}Operating system not supported: ${os}${NO_COLOR}"
        ;;
    esac
}

function flash_sdcard() {
    sdcard=$1
    image=$2
    os=$3
    case "${os}" in
        "OSX")
            sudo dd if=${image} of=${sdcard} bs=4m
            sync
            ;;
        "LINUX")
            sudo dd if=${image} of=${sdcard} bs=4M
            sync
            ;;
        *)
            echo -e "${ERROR_COLOR}Operating system not supported: ${os}${NO_COLOR}"
            ;;
    esac
}
