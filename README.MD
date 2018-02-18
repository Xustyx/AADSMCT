# Another AWS Docker Swarm mode cluster template
A template for create a **Docker Swarm mode** cluster on **AWS**.


## Getting Started
These instructions will get you a copy of the project up and running on your cloud server for development and testing 
purposes.

- **CARE!!!** This template runs **(5) t2.micro** instances by default, it will be consume 5 hours of free tier once per 
execution.


### Prerequisites
For run this project you need:
 - [Amazon AWS account](https://aws.amazon.com) - Amazon cloud server
 - [Amazon AWS EC2 user](https://aws.amazon.com) - User with EC2 permissions
 - [Terraform](https://www.terraform.io/) - Write, Plan, and Create Infrastructure as Code
 - [Ansible](https://www.ansible.com/) - Automation for everyone


### Setup
First of all you must create an aws account and install all prerequisites, you can find it easy on their website.

When you are done with prerequisites, you can simply run the `setup.sh` script inside the folder `inventory`, it must 
create a ssh keypair and export all environment variables that project need if required.

```bash
## Note that script is invoked using source
source setup.sh
```

Another way is to setup environment manually following those steps that maybe you don't need to do:

Export environment variable **AWS_ACCESS_KEY_ID** with the access key id of user with **EC2 permissions**.
```bash
## Example: replace XXXXXXXXXXXXX for your key id
export AWS_ACCESS_KEY_ID=XXXXXXXXXXXXX
```

Export environment variable **AWS_SECRET_ACCESS_KEY** with the access secret key of user with **EC2 permissions**.
```bash
## Example: replace XXXXXXXXXXXXX for your access key
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXX
```

Export environment variable **AWS_DEFAULT_REGION** with the region on cluster must be deployed.
```bash
## Example: replace at-narnia-2 for your region
export AWS_DEFAULT_REGION=at-narnia-2
```

Export environment variable **ANSIBLE_HOST_KEY_CHECKING** to avoid fingerprint check.
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
```

Create a ssh keypair with and put the keys on `inventory` folder as `sw-aws-key` and `sw-aws-key.pub`.
```bash
## Example: you can generate the key as you want
ssh-keygen -f sw-aws-key -t rsa -b 4096 -N "" -C "" -q
chmod 400 sw-aws-key
```

Once you completed all you can be able to see exported vars with `env` command and the public key file on `inventory` 
folder.


### Configuration
You can adjust all cluster nodes number and instance types on `variables.tf` file.


### Run
When you ready, you can run the commands below to create the cluster.

```bash
## Init the providers
terraform init

## Check the plan
terraform plan

## Apply the plan
terraform apply

## WAIT!!! until aws instances start up

## Run Ansible
ansible-playbook -i ./inventory/hosts --private-key ./inventory/sw-aws-key playbook.yml
```


## Bootstrap
A fast way to run this if you don't like read.

```bash
#!/usr/bin/env bash

# Clone the repository
git clone ${this.repository.url}

# Move to inventory folder
cd ./${this.project.dir}/inventory

# Run setup script
source setup.sh

# Move backwards
cd ..

# Run terraform stuff
terraform init
terraform plan
terraform apply

## WAIT!!! until aws instances start up
sleep 60

# Run ansible stuff
ansible-playbook -i ./inventory/hosts --private-key ./inventory/sw-aws-key playbook.yml

## GG
```


## Remove
To remove all the cluster you only need to run this command:

```bash
terraform destroy
```


## Built With
 - [Amazon AWS cloud](https://aws.amazon.com) - Amazon cloud server
 - [Terraform](https://www.terraform.io/) - Write, Plan, and Create Infrastructure as Code
 - [Ansible](https://www.ansible.com/) - Automation for everyone
 

## Disclaimer
The author can not be held liable for any use of this code.
