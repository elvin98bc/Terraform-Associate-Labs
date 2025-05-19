terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.58.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0afc7fe9be84307e4"
  instance_type = "t2.micro"

  tags = {
    Name = "MyServer"
  }
}
