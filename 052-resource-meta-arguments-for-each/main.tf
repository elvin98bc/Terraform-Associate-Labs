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
	for_each = {
		nano = "t2.nano"
		micro =  "t2.micro"
		small =  "t2.small"
	}
  ami           = data.aws_ami.ubuntu.owner_id
  instance_type = each.value
	tags = {
		Name = "Server-${each.key}"
	}
}

output "public_ip" {
  value = values(aws_instance.my_server)[*].public_ip
}