# Copyright (C) 2016-2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>
#
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

{% set docker_version = {
  'Debian': pillar['docker']['debian_version'],
  'Ubuntu': pillar['docker']['ubuntu_version'],
}.get(grains.os) %}

{% set gpg = {
    'Debian': 'https://download.docker.com/linux/debian/gpg',
    'Ubuntu': 'https://download.docker.com/linux/ubuntu/gpg',
}.get(grains.os) %}

{% set repo = {
    'Debian': '"deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"',
    'Ubuntu': '"deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"',
}.get(grains.os) %}

docker.repo:
  pkgrepo.managed:
    - humanname: Docker Repository
    - name: {{ repo }}
    - file: /etc/apt/sources.list.d/deb-docker.list
    - key_url: {{ gpg }}

# docker.customization:
#   file.managed:
#     - source: salt://docker/overlay.conf
#     - target: /etc/systemd/system/docker.service.d/overlay.conf
#     - user: root
#     - group: root
#     - mode: 644

docker.packages:
  pkg.installed:
    - pkgs:
      - docker-ce: {{ docker_version }}

docker.service:
  service.running:
    - name: docker
    - enable: True
