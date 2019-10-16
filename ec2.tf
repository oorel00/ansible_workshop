provider "aws" {
  region     = var.region
}

resource "aws_instance" "ansible" {
  ami               = var.amis[var.region]
  instance_type     = var.instance_type
  availability_zone = "us-east-2a"
  key_name          = var.key_name
  security_groups   = ["default"]
  tags   = {
    Name = "ansible"
  }
}

resource "aws_instance" "managed_node" {
  count             = 3
  ami               = var.amis[var.region]
  instance_type     = var.instance_type
  availability_zone = "${var.region}${element(var.zones, count.index)}"
  key_name          = var.key_name
  security_groups   = ["default"]
  tags   = {
    Name = "node${count.index+1}"
  }
}

