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

jarvis:
  user.present:
    - fullname: Zeiot Jarvis
    - shell: /bin/bash
    - home: /home/jarvis
    - uid: 4000
    - gid: 4000
    - groups:
      - users
      - docker

/home/jarvis/bin:
  file.directory:
    - user: jarvis
    - group: infra
    - mode: 755
    - makedirs: True

/home/jarvis/.bashrc:
  file.managed:
    - source: salt://server/bashrc
    - user: jarvis
    - group: infra
    - mode: 755
