provider "aws" {
  region = var.aws_region
}
# Pair ssh local keys (private + public)
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Save the private key .pem
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = ".ssh/terra.pem"
  file_permission = "0400"
}
# Keys EC2 
resource "aws_key_pair" "generated_key" {
  key_name   = "terra"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

#Creation frontend instance
resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags                   = { Name = "frontend" }
  key_name               = aws_key_pair.generated_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  subnet_id = aws_subnet.monitoring_a.id
  associate_public_ip_address = true

#run playbook ansible local
   provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ansible/playbook.yml -u ec2-user -i ansible/inv.ini --private-key .ssh/terra.pem"
  }
}

#backend instance
resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  tags                   = { Name = "backend" }
  key_name               = aws_key_pair.generated_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  subnet_id = aws_subnet.monitoring_a.id
  associate_public_ip_address = true

#run playbook ansible local
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ansible/playbook.yml -u ec2-user -i ansible/inv.ini --private-key .ssh/terra.pem"
  }
}

#database instance
resource "aws_instance" "db" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  tags                   = { Name = "database" }
  key_name               = aws_key_pair.generated_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.monitoring.id]
  subnet_id = aws_subnet.monitoring_a.id
  associate_public_ip_address = true

#run playbook ansible local
   provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook ansible/playbook.yml -u ec2-user -i ansible/inv.ini --private-key .ssh/terra.pem"
  }
}

resource "local_file" "ansible_inventory" {
  file_permission = "0644"
  content = <<EOF
[frontend]
frontend ansible_host=${aws_instance.frontend.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=../.ssh/terra.pem

[backend]
backend ansible_host=${aws_instance.backend.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=../.ssh/terra.pem

[db]
db ansible_host=${aws_instance.db.private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=../.ssh/terra.pem

[app:children]
frontend
backend
db
EOF
  
  filename = "${path.module}/ansible/inv.ini"
}



output "frontend_ip" { value = aws_instance.frontend.public_ip }
output "backend_ip" { value = aws_instance.backend.public_ip }
output "db_ip" { value = aws_instance.db.private_ip }