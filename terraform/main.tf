provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-terraform-key"
  public_key = file("~/.ssh/my-terraform-key.pub")
}

resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = { Name = "frontend" }
  key_name      = aws_key_pair.deployer.key_name
}


resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = { Name = "backend" }
  key_name      = aws_key_pair.deployer.key_name
}

resource "aws_instance" "db" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = { Name = "database" }
  key_name      = aws_key_pair.deployer.key_name
}

output "frontend_ip" { value = aws_instance.frontend.public_ip }
output "backend_ip"  { value = aws_instance.backend.public_ip }
output "db_ip"       { value = aws_instance.db.private_ip }