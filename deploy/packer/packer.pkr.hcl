packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "mexe-ami-{{timestamp}}"
  instance_type = "t3.small"
  region        = "ap-southeast-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}


build {
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "shell" {
    inline = [
      "set -eux",

      # Update system
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",

      # Install Nginx
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",

      # Install Docker
      "curl -fsSL https://get.docker.com | sh",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl enable docker",

      # Install Docker Compose
      "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",

      # Install Git
      "sudo apt-get install -y git",

      # Install Node.js (LTS, via NodeSource)
      "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -",
      "sudo apt-get install -y nodejs build-essential",

      # Create app directory
      "sudo mkdir -p /opt/app && sudo chown ubuntu:ubuntu /opt/app"
    ]
  }
}
