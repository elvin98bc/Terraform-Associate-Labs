terraform { 
  cloud { 
    organization = "elvin98bc-devops-learning" 

    workspaces { 
      name = "getting-started" 
    } 
  }

}

provider "aws" {
  region = "ap-southeast-1"
}

data "aws_vpc" "main" {
  id = "vpc-028d38da7adc5c214"
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
			security_groups = []
			self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["161.142.151.160/32"]
      ipv6_cidr_blocks = []
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]

  egress = [
    {
			description = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
			prefix_list_ids  = []
			security_groups = []
			self = false
    }
  ]
}

data "template_file" "user_data" {
	template = file("./userdata.yaml")
}

data "local_file" "config" {
	filename = file("./config.json")
}

resource "aws_instance" "my_server" {
  ami           = "ami-087c17d1fe0178315"
  instance_type = "t2.micro"
	key_name = "mynewkeypair"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
	user_data = data.template_file.user_data.rendered
  provisioner "file" {
    source     = "./config.json"
    destination = "/home/ec2-user/config.json"
		connection {
			type     = "ssh"
			user     = "ec2-user"
			host     = "${self.public_ip}"
      private_key = file("/Users/elvinchieng/Downloads/mynewkeypair.pem")
		}
  }

  tags = {
    Name = "MyServer"
  }
}

output "public_ip"{
	value = aws_instance.my_server.public_ip
}