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

{% set k8s_version = pillar['kubernetes']['k8s_version'] %}
{% set k8s_cni_version = pillar['kubernetes']['k8s_cni_version'] %}

kubernetes-repo:
  pkgrepo.managed:
    - humanname: Kubernetes Repository
    - name: deb http://apt.kubernetes.io/ kubernetes-xenial main
    - file: /etc/apt/sources.list.d/deb-kubernetes.list
    - key_url: https://packages.cloud.google.com/apt/doc/apt-key.gpg

kubernetes-packages:
  pkg.installed:
    - pkgs:
      # - kubeadm: {{ k8s_version }}
      - kubectl: {{ k8s_version }}
      - kubelet: {{ k8s_version }}
      - kubernetes-cni: {{ k8s_cni_version }}

bash-completion:
  cmd.run:
    - name: kubectl completion bash > /etc/bash_completion.d/kubectl

kubelet-service:
  service.running:
    - name: kubelet
    - enable: True

setup-ipv4:
  cmd.run:
    - name: sysctl net.bridge.bridge-nf-call-iptables=1
