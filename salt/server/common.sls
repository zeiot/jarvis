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

us_locale:
  locale.present:
    - name: en_US.UTF-8

default_locale:
  locale.system:
    - name: en_US.UTF-8
    - require:
      - locale: us_locale

# en_US.UTF-8:
#   file.uncomment:
#     - name: /etc/locale.gen
#     - regex: en_US.UTF-8 UTF-8
#     - char: '# '
#     - require:
#       - pkg: locales
#     - watch_in:
#       - cmd: locales
#   locale:
#     - system

Europe/Paris:
  timezone.system

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
