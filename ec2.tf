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
      private_key = file(local.private_key)
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
      private_key = file(local.private_key)
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
      private_key = file(local.private_key)
    }
  }
}

resource "tls_private_key" "ansible" {
  algorithm = "RSA"
}

locals {
  private_key = join(".",[var.key_name,"pem"])
  inventory   = "/tmp/inventory"
}

resource "local_file" "ansible_private_key" {
  sensitive_content  = tls_private_key.ansible.private_key_pem
  filename           = ".ssh/ansible.pem"
  file_permission    = "0400"
}

output "ansible_control_node_connection_info" {
  value = "ssh -i ${local.private_key} ${var.username}@${aws_instance.ansible.public_ip}"
}

output "ansible_inventory" {
  value = local.inventory
}

