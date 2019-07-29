# Copyright (C) 2016-2019 Nicolas Lamirault <nicolas.lamirault@gmail.com>

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

resource "google_container_cluster" "jarvis-gke" {
  provider           = "google-beta"
  project            = "${var.project}"
  name               = "${var.name}-${var.env}-gke"
  region             = "${var.region}"
  min_master_version = "${data.google_container_engine_versions.available.latest_master_version}"
  logging_service    = "logging.googleapis.com"
  monitoring_service = "monitoring.googleapis.com"

  remove_default_node_pool = true
  initial_node_count       = 1

  addons_config {
    istio_config {
      disabled = false
    }
  }
}

resource "google_container_node_pool" "jarvis-gke-node-pool" {
  project    = "${var.project}"
  name       = "${var.name}-${var.env}-gke"
  region     = "${var.region}"
  cluster    = "${google_container_cluster.jarvis-gke.name}"
  node_count = 1

  # version = "${data.google_container_engine_versions.available.latest_node_version}"
  version = "${var.kubernetes_version}"

  management {
    auto_repair = true
  }

  autoscaling {
    min_node_count = "${var.min_node}"
    max_node_count = "${var.max_node}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    preemptible  = "${var.preemptible}"
    image_type   = "COS"
    machine_type = "n1-standard-1"
  }

  timeouts {
    create = "120m"
    update = "120m"
    delete = "120m"
  }
}
