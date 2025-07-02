variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-west-3"
}
variable "ami_id" {
  description = "Amazon Linux 2023 kernel-6.1 AMI"
  default     = "ami-0f8d3c5dcfaceaa4f"
}
variable "instance_type" {
  default = "t3.micro"
}

variable "public_key_path" {
  description = "Chemin vers la clé publique SSH"
  default     = "~/.ssh/my-terraform-key.pub"
}

variable "private_key_path" {
  description = "Chemin vers la clé privée SSH"
  default     = "~/.ssh/my-terraform-key"
}