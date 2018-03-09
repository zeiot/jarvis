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

resource "openstack_compute_instance_v2" "jarvis-nodes" {
  count           = "${var.jarvis_nb_nodes}"
  region          = "${var.openstack_region}"
  name            = "${var.cluster_name}-node-${count.index}" // => `jarvis-node-{0,1,2}`
  image_id        = "${var.openstack_image_id}"
  flavor_name     = "${var.openstack_instance_type_node}"
  key_pair        = "${var.openstack_key_name}"
  security_groups = ["${openstack_compute_secgroup_v2.jarvis-sg.name}"]

  network {
    uuid = "${openstack_networking_network_v2.jarvis-network.id}"
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

  connection {
    user        = "${var.ssh_user_name}"
    private_key = "${file("${var.ssh_key_file}")}"
  }

}
