#!/bin/sh

# Install docker
yum update
yum install -y docker

# Start docker
service docker start

# Add default aws user to docker group
usermod -aG docker ec2-user

# You can add more stuff here if you need