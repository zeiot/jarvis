# Copyright (C) 2017-2018 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

resource "aws_instance" "jarvis-nodes" {
  depends_on      = ["aws_eip.ip"]
  count           = "${var.jarvis_nb_nodes}"
  ami             = "${var.aws_image}"
  instance_type   = "${var.aws_instance_type_node}"
  key_name        = "${var.aws_key_name}"
  subnet_id       = "${aws_subnet.jarvis-network.id}"
  security_groups = [
    "${aws_security_group.jarvis-network.id}",
  ]
  tags {
    Name = "${var.cluster_name}-node-${count.index}"
  }

  connection {
    user     = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent    = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i -r  's/127.0.0.1 localhost/127.0.0.1 localhost ${var.cluster_name}-node-${count.index}/' /etc/hosts",
      "curl -s -O https://packages.cloud.google.com/apt/doc/apt-key.gpg",
      "sudo apt-key add ./apt-key.gpg",
      "sudo add-apt-repository -y 'deb http://apt.kubernetes.io/ kubernetes-xenial main'",
      "sudo apt-get -y -qq update",
      "sudo apt-get -y -qq upgrade",
      "sudo apt-get install -y -q apt-transport-https docker.io",
      "sudo systemctl start docker.service",
      "sudo apt-get -y -q update",
      "sudo apt-get install -y -q htop kubelet kubeadm kubectl kubernetes-cni",
      "sudo service kubelet restart",
      "sudo kubeadm init --token ${var.kubeadm_token} --kubernetes-version ${var.kubeadm_token}",
      "sudo cp -v /etc/kubernetes/admin.conf /home/ubuntu/config",
      "sudo chown ubuntu /home/ubuntu/config",
      "kubectl apply -f https://git.io/weave-kube",
    ]
  }

}
