#!/usr/bin/env bash

set -e
set -u
set -x

apt update
apt install -y ruby unzip kpartx parted grub curl

wget http://s3.amazonaws.com/ec2-downloads/ec2-ami-tools.zip
mkdir -p /usr/local/ec2
unzip ec2-ami-tools.zip -d /usr/local/ec2
mv /usr/local/ec2/ec2-ami-tools-* /usr/local/ec2/ec2-ami-tools
