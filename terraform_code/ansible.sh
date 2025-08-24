#!/bin/bash
# Update packages
apt update -y

# Install Python + dependencies
apt install -y python3 python3-pip python3-venv

# Install Ansible + boto3 (AWS SDK)
apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible
pip3 install boto3 botocore

# (Optional) Set default region so you don’t need to pass --region every time
mkdir -p /home/ubuntu/.aws
cat > /home/ubuntu/.aws/config <<EOF
[default]
region=us-east-1
output=json
EOF
chown -R ubuntu:ubuntu /home/ubuntu/.aws

# Create dynamic inventory config
mkdir -p /opt/ansible
cat > /opt/ansible/aws_ec2.yml <<EOF
plugin: aws_ec2
regions:
  - us-east-1
filters:
  tag:Project: dpp
  instance-state-name: running
keyed_groups:
  - key: tags.Name
    prefix: ""
hostnames:
  - private-ip-address
compose:
  ansible_user: ubuntu
  ansible_ssh_private_key_file: /opt/dpp.pem
EOF

chown -R ubuntu:ubuntu /opt/ansible

echo "✅ Ansible + boto3 + aws_ec2 inventory configured successfully" > /tmp/ansible_setup.log
