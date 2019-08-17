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

# When ARM releases will be availables

# exa_archive:
#   archive.extracted:
#     - name: /usr/local/src/exa
#     - source: https://github.com/ogham/exa/releases/download/v{{ system.tools.exa.version }}/exa-linux-x86_64-{{ system.tools.exa.version }}.zip
#     - keep_source: false
#     - skip_verify: true
#     - enforce_toplevel: false
# exa_bin:
#   file.symlink:
#     - name: /usr/local/bin/exa
#     - target: /usr/local/src/exa/exa-linux-x86_64
# {% if system.tools.exa.alias %}
# exa_alias:
#   file.managed:
#     - name: /root/.bash_aliases.d/exa
#     - user: 'root'
#     - group: 'root'
#     - mode: '0644'
#     - contents:
#       - "alias ll='exa -l'"
# {% endif %}
# {% endif %}

# {% if system.tools.ripgrep and salt['grains.get']('os') == 'Debian' and salt['grains.get']('osarch') == 'amd64' %}
# install_ripgrep:
#   pkg.installed:
#     - sources:
#       - ripgrep: https://github.com/BurntSushi/ripgrep/releases/download/{{ system.tools.ripgrep.version }}/ripgrep_{{ system.tools.ripgrep.version }}_arm64.deb
# {% if system.tools.ripgrep.alias %}
# ripgrep_alias:
#   file.managed:
#     - name: /root/.bash_aliases.d/ripgrep
#     - user: 'root'
#     - group: 'root'
#     - mode: '0644'
#     - contents:
#       - "alias grep='rg'"
# {% endif %}
# {% endif %}

# {% if system.tools.fd and salt['grains.get']('os') == 'Debian' and salt['grains.get']('osarch') == 'amd64' %}
# install_fd:
#   pkg.installed:
#     - sources:
#       - fd: https://github.com/sharkdp/fd/releases/download/v{{ system.tools.fd.version }}/fd_{{ system.tools.fd.version }}_arm64.deb
# {% if system.tools.fd.alias %}
# fd_alias:
#   file.managed:
#     - name: /root/.bash_aliases.d/fd
#     - user: 'root'
#     - group: 'root'
#     - mode: '0644'
#     - contents:
#       - "alias find='fd'"
# {% endif %}
# {% endif %}
