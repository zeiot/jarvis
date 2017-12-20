#!/bin/bash

venv=$1
echo "Home Assistant: ${venv}"
dir=$2
echo "Configuration: ${dir}"
. ${venv}/venv/bin/activate && \
        python3 -m homeassistant --config ${dir}
