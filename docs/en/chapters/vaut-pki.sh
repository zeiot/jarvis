# Copyright (C) 2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

#!/bin/bash

# Create ROOT CA for Jarvis
# --------------------------------------------------------

vault secrets enable -path=jarvis-pki pki
vault secrets tune -max-lease-ttl=87600h jarvis-pki
vault write jarvis-pki/root/generate/internal common_name="Jarvis" ttl=87600h

vault write jarvis-pki/config/urls \
    issuing_certificates="${VAULT_ADDR}/v1/jarvis-pki/ca" \
    crl_distribution_points="${VAULT_ADDR}/v1/jarvis-pki/crl"

vault write jarvis-pki/roles/jarvis-role allowed_domains=kube.jarvis allow_subdomains=true max_ttl=8760h

# Create Intermediate CA for Jarvis Kubernetes
# --------------------------------------------------------

vault secrets enable -path=jarvis-k8s-pki pki
vault secrets tune -max-lease-ttl=43800h jarvis-k8s-pki
# vault secrets tune -default-lease-ttl=4380h jarvis-k8s-pki
# > pki.csr
vault write jarvis-k8s-pki/intermediate/generate/internal common_name="Jarvis Kubernetes" ttl=43800h

# Sign Int CA with ROOT CA
vault write jarvis-pki/root/sign-intermediate csr=@jarvis-pki.csr format=pem_bundle ttl=43800h

# > signed_certificate.pem
vault write jarvis-k8s-pki/intermediate/set-signed certificate=@signed_certificate.pem
vault write jarvis-k8s-pki/config/urls \
    issuing_certificates="${VAULT_ADDR}/v1/jarvis-k8s-pki/ca" \
    crl_distribution_points="${VAULT_ADDR}/v1/jarvis-k8s-pki/crl"

# Create Role
