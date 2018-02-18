#!/usr/bin/env bash

# This script it's not required but maybe useful
# for newbies like me

# Check and set terraform env vars
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
    read -p "Set the AWS_ACCESS_KEY_ID: " AWS_ACCESS_KEY_ID
    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
fi

if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    read -p "Set the AWS_SECRET_ACCESS_KEY: " AWS_SECRET_ACCESS_KEY
    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
fi

if [ -z "$AWS_DEFAULT_REGION" ]; then
    read -p "Set the AWS_DEFAULT_REGION: " AWS_DEFAULT_REGION
    export AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
fi

# Set Ansible host key check to false to avoid fingerprint check
export ANSIBLE_HOST_KEY_CHECKING=False

# Create keypair
if [ ! -f sw-aws-key.pub ]; then
    echo "Key file not found, generating a new pair..."
    ssh-keygen -f sw-aws-key -t rsa -b 4096 -N "" -C "" -q
    chmod 400 sw-aws-key
fi


