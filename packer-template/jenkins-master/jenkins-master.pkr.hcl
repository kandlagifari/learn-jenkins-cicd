packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

source "amazon-ebs" "jenkins-master" {
  ami_description = "Amazon Linux Image with Jenkins Master"
  ami_name        = "jenkins-master-2.204.1-{{timestamp}}"
  instance_type   = "${var.instance_type}"
  profile         = "${var.aws_profile}"
  region          = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ec2-user"
  tags = {
    "Name"        = "Jenkins Master"
    "Environment" = "SandBox"
    "OS_Version"  = "Amazon Linux 2"
    "Release"     = "Latest"
    "Created-by"  = "Packer"
  }
}

build {
  name    = "jenkins-master"
  sources = ["source.amazon-ebs.jenkins-master"]

  provisioner "file" {
    destination = "/tmp/"
    source      = "./scripts"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "./config"
  }

  provisioner "file" {
    destination = "/tmp/id_rsa"
    source      = "${var.ssh_key}"
  }

  provisioner "shell" {
    execute_command = "sudo -E -S sh '{{ .Path }}'"
    script          = "./setup-jenkins-master.sh"
  }
}
