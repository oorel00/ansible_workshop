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
  provisioner "file" {
    content = tls_private_key.ansible.private_key_pem
    destination = ".ssh/id_ecdsa"
    connection {
      type = "ssh"
      host = self.public_ip
      user = var.username
      private_key = file("workshop.pem")
    }
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 0400 .ssh/id_ecdsa"
    ]
    connection {
      type = "ssh"
      host = self.public_ip
      user = var.username
      private_key = file("workshop.pem")
    }
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
  provisioner "file" {
    content = tls_private_key.ansible.public_key_openssh
    destination = ".ssh/authorized_keys"
    connection {
      type = "ssh"
      host = self.public_ip
      user = var.username
      private_key = file("workshop.pem")
    }
  }
}

resource "tls_private_key" "ansible" {
  algorithm = "RSA"
}
