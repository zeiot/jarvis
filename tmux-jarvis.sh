#!/bin/bash

# Copyright (C) 2016-2017 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

SESSION="jarvis"

function tmux-jarvis {
    tmux start-server
    tmux new-session -s $SESSION -n Jarvis-d
    tmux new-window -n "Jarvis"
    tmux send-keys -t $SESSION "cd ${HOME}/Perso/Zeiot/jarvis" C-m
    tmux new-window -n "Ctop"
    tmux send-keys -t $SESSION "cd ${HOME}" C-m
    tmux new-window -n "Charts"
    tmux send-keys -t $SESSION "cd ${HOME}" C-m
    tmux attach-session -t $SESSION
}

tmux-jarvis
