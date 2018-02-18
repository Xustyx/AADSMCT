variable "key_path" {
  description = "SSH Public Key path"
  default = "./inventory/sw-aws-key.pub"
}

variable "bootstrap_path" {
  description = "Path to bash script to bootstrap installation"
  default = "./inventory/install-docker-al2.sh"
}

variable "ami" {
  description = "Amazon Linux Image to use ( Amazon Linux 2 LTS Candidate AMI 2017.12.0 (HVM), SSD Volume Type )"
  default = "ami-5ce55321"
}

variable "leader_instance_type" {
  description = "The type of leader instance"
  default = "t2.micro"
}

variable "master_instance_type" {
  description = "The type of master instance"
  default = "t2.micro"
}

variable "master_instance_numer" {
  description = "The number of master instances #(0, 2, 4, 6)"
  default = "2"
}

variable "worker_instance_type" {
  description = "The type of worker instance"
  default = "t2.micro"
}

variable "worker_instance_numer" {
  description = "The number of worker instances #(0..n)"
  default = "2"
}



