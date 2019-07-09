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

salt_minion_conf_set:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://salt/templates/minion
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - require:
      - pkg: salt-minion

# Check service is running
salt_minion_service_running:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion

# Refresh configuration every 15 minutes.
salt_minion_highstate_cron_set:
  cron.present:
    - identifier: salt_minion_highstate_cron_set
    - name: salt-call state.highstate > /dev/null
    - user: root
    - minute: '*/15'