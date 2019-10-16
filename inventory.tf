data "template_file" "inventory" {
  template = file("${path.module}/inventory.tpl")
  vars = {
    node_ips    = join(",",aws_instance.managed_node.*.public_ip)
    control_ip  = aws_instance.ansible.public_ip
  }
}

resource "null_resource" "inventory" {
  provisioner "file" {
    content     = data.template_file.inventory.rendered
    destination = local.inventory
    connection {
      type = "ssh"
      host = aws_instance.ansible.public_ip
      user = var.username
      private_key = file(local.private_key)
    }
  }
}
