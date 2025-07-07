variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}
variable "ami_id" {
  description = "Amazon Linux 2023 kernel-6.1 AMI"
  default     = "{{certs.ami-id}}"
}
variable "instance_type" {
  default = "t3.micro"
}

variable "public_key_path" {
  description = "Chemin vers la clé publique SSH"
  default     = ".ssh/terra.pub"
}

variable "private_key_path" {
  description = "Chemin vers la clé privée SSH"
  default     = ".ssh/terra"
}

variable "account_id" {
  description = "Hard coded value AWS account"
  default     = "{{certs.account-aws-id}}"

}