terraform {
}

module "aws_server" {
	source = ".//aws_server"
	instance_type = "t2.small"
}

output "public_ip" {
  value = module.aws_server.public_ip
}