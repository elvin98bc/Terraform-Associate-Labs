terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.59.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "main" {
  id = "vpc-028d38da7adc5c214"
}

data "local_file" "config" {
  filename = "${path.module}/config.json"
}
locals {
  ssh_connection = {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/Users/elvinchieng/Downloads/mynewkeypair.pem")
  }

  # config_hash = sha256(file("${path.module}/config.json"))
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["161.142.151.160/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_instance" "my_server" {
  ami                    = "ami-0afc7fe9be84307e4"
  instance_type          = "t2.micro"
  key_name               = "mynewkeypair"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data              = templatefile("${path.module}/userdata.yaml", {})
  tags = {
    Name = "MyServer"
  }
}

resource "null_resource" "init_instance" {
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ec2-user/barsoon",
      "echo ${aws_instance.my_server.private_ip} > /home/ec2-user/barsoon/hello.txt"
    ]

    connection {
      host        = aws_instance.my_server.public_ip
      type        = local.ssh_connection.type
      user        = local.ssh_connection.user
      private_key = local.ssh_connection.private_key
    }
  }

  depends_on = [aws_instance.my_server]
}

resource "terraform_data" "config_input" {
  input = file("${path.module}/config.json")
}
resource "null_resource" "copy_config" {
  triggers = {
    config_hash = terraform_data.config_input.input
  }
  provisioner "file" {
    source      = "${path.module}/config.json"
    destination = "/home/ec2-user/barsoon/config.json"

    connection {
      host        = aws_instance.my_server.public_ip
      type        = local.ssh_connection.type
      user        = local.ssh_connection.user
      private_key = local.ssh_connection.private_key
    }
  }

  depends_on = [null_resource.init_instance]
}

resource "null_resource" "log_config_change" {
  triggers = {
    config_hash = terraform_data.config_input.input
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"Config changed at $(date '+%Y-%m-%d %H:%M:%S')\" >> /home/ec2-user/barsoon/hello.txt"
    ]

    connection {
      host        = aws_instance.my_server.public_ip
      type        = local.ssh_connection.type
      user        = local.ssh_connection.user
      private_key = local.ssh_connection.private_key
    }
  }

  depends_on = [null_resource.copy_config]
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}