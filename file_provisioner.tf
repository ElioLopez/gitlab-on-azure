data "template_file" "docker_compose" {
  template = "${file("./docker-compose.tpl")}"

  vars = {
    IP_ADDR = "${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}"
    GITLAB_HOME = "/home/azureuser/gitlab"
  }
}

variable "output_file_name" {
  default = "docker-compose.json"
}

#render docker-compose.yaml file locally
resource "null_resource" "test" {
  triggers = {
    test = "${data.template_file.docker_compose.rendered}"
  }
  provisioner "local-exec" {
        command = "${format("cat <<\"EOF\" > \"%s\"\n%s\nEOF", var.output_file_name, data.template_file.docker_compose.rendered)}"
  }
}


#copy the previuosly rendered file to the created VM
resource "null_resource" remoteExecProvisionerWFolder {

  provisioner "file" {
    source      = "${var.output_file_name}"
    destination = "/home/azureuser/docker-compose.yaml"
  }

  connection {
    host        = "${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}"
    type        = "ssh"
    user        = "azureuser"
    private_key = "${tls_private_key.example_ssh.private_key_pem}"
    agent       = "false"
  }
}