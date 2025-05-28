terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_server" {
	count = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.nano"
	tags = {
		Name = "Server-${count.index}"
	}
}

output "public_ip" {
  value = aws_instance.my_server[*].public_ip
}

### if done some changes in the code, but not re-provisioning resources, like change tag name etc, can use tf apply -refresh-only