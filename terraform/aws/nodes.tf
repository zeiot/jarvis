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
  depends_on = ["aws_eip.ip"]
  count = "${var.jarvis_nb_nodes}"
  ami = "${var.aws_image}"
  instance_type = "${var.aws_instance_type_node}"
  key_name = "${var.aws_key_name}"
  subnet_id = "${aws_subnet.jarvis-network.id}"
  security_groups = [
    "${aws_security_group.jarvis-network.id}",
  ]
  tags {
    Name = "jarvis-node-${count.index}"
  }

  connection {
    user = "${var.aws_ssh_user}"
    key_file = "${var.aws_ssh_private_key_file}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      # "sudo apt-get -y upgrade",
      "sudo apt-get install -y python2.7"
    ]
  }

}
