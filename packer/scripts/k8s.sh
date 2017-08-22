#!/usr/bin/env bash

set -e
set -u
set -x

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial-unstable main
EOF

apt-get update

apt install -y kubelet=${K8S_VERSION} kubectl=${K8S_VERSION} kubeadm=${K8S_VERSION} kubernetes-cni=${CNI_VERSION}
