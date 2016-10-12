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

RASPBIAN_VERSION=2016-09-28
RASPBIAN_NUMBER=2016-09-23

echo -e "${OK_COLOR}== Raspbian Lite for Raspberry Pi ==${NO_COLOR}"
if [ $# -ne 1 ]; then
    display_usage
fi

os=$(get_os)
echo -e "${WARN_COLOR}Operating system: $os${NO_COLOR}"

sdcard=$(get_sdcard $1 ${os})
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the root filesystem${NO_COLOR}"
if [ ! -f "${RASPBIAN_NUMVER}-raspbian-jessie-lite.zip" ]; then
    curl -LO --progress-bar http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-${RASPBIAN_VERSION}/${RASPBIAN_NUMBER}-raspbian-jessie-lite.zip
fi

echo -e "${WARN_COLOR}Extracting the image${NO_COLOR}"
if [ ! -f "${RASPBIAN_NUMBER}-raspbian-jessie-lite.img" ]; then
     unzip ${RASPBIAN_NUMBER}-raspbian-jessie-lite.zip
fi

setup_sdcard $(sdcard) $(os)

echo -e "${WARN_COLOR}Installing OSMC to SD Card${NO_COLOR}"
flash_sdcard ${sdcard} OSMC_TGT_rpb2_${osmc_img_version}.img ${os}

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"
