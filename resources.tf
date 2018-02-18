## SSH key pair for swarm
resource "aws_key_pair" "sw-ssh-key" {
  key_name = "sw-ssh-key"
  public_key = "${file("${var.key_path}")}"
}

## Swarm ports -> https://gist.github.com/BretFisher/7233b7ecf14bc49eb47715bbeb2a2769
resource "aws_security_group" "sw_sg" {
  name = "sw_sg"
  description = "Allow all traffic necessary for Swarm"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 2377
    to_port = 2377
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 7946
    to_port = 7946
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 7946
    to_port = 7946
    protocol = "udp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 4789
    to_port = 4789
    protocol = "udp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags {
    Name = "sw_sg"
  }
}


## Create a root manager node ( LEADER )
resource "aws_instance" "sw-leader" {
  depends_on = [
    "aws_security_group.sw_sg",
    "aws_key_pair.sw-ssh-key"]
  ami = "${var.ami}"
  instance_type = "${var.leader_instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.sw_sg.id}"]
  key_name = "${aws_key_pair.sw-ssh-key.id}"
  user_data = "${file("${var.bootstrap_path}")}"

  tags {
    Name = "sw-leader"
  }
}

## Create manager nodes
resource "aws_instance" "sw-master" {
  depends_on = [
    "aws_security_group.sw_sg",
    "aws_key_pair.sw-ssh-key"]
  ami = "${var.ami}"
  instance_type = "${var.master_instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.sw_sg.id}"]
  key_name = "${aws_key_pair.sw-ssh-key.id}"
  count = "${var.master_instance_numer}"
  user_data = "${file("${var.bootstrap_path}")}"

  tags {
    Name = "sw-master-${count.index}"
  }
}

## Create woerker nodes
resource "aws_instance" "sw-worker" {
  depends_on = [
    "aws_security_group.sw_sg",
    "aws_key_pair.sw-ssh-key"]
  ami = "${var.ami}"
  instance_type = "${var.worker_instance_type}"
  vpc_security_group_ids = [
    "${aws_security_group.sw_sg.id}"]
  key_name = "${aws_key_pair.sw-ssh-key.id}"
  count = "${var.worker_instance_numer}"
  user_data = "${file("${var.bootstrap_path}")}"

  tags {
    Name = "sw-worker-${count.index}"
  }
}


## Create Hosts file
resource "null_resource" "ansible-provision" {
  depends_on = [
    "aws_instance.sw-leader",
    "aws_instance.sw-master",
    "aws_instance.sw-worker"]

  provisioner "local-exec" {
    command = "echo [leader] > ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.sw-leader.0.public_ip} >> ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = "echo [masters] >> ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = "echo -e '${join("\n", aws_instance.sw-master.*.public_ip)}' >> ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = "echo [workers] >> ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    command = "echo -e '${join("\n", aws_instance.sw-worker.*.public_ip)}' >> ./inventory/hosts"
    interpreter = ["bash", "-c"]
  }
}