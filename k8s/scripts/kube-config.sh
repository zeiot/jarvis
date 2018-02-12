#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <master ip>"
    exit 1
fi

address=$1
echo "Kubernetes master: ${address}"
kubectl config set-cluster admin \
  --server=https://$address:6443 \
  --certificate-authority=/etc/kubernetes/pki/ca.crt \
  --embed-certs=true
kubectl config set-credentials admin \
  --client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt \
  --client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key \
  --embed-certs=true
kubectl config set-context admin \
  --cluster=admin \
  --user=admin
kubectl config use-context admin

cat ~/.kube/config >> /tmp/config
