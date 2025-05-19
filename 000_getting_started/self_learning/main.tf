resource "aws_instance" "app_server" {
  ami           = "ami-0afc7fe9be84307e4"
  instance_type = var.instance_type

  tags = {
    Name = "MyServer-${local.project_name}"
  }
}