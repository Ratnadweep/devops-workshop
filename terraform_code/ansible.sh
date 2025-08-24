#!/bin/bash
apt update -y
apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible
echo "Ansible installed successfully on $(hostname)" > /tmp/ansible_install.log