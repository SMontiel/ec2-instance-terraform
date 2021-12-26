variable "name" {
  description = "the name of your project, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. 'test'"
  default     = "test"
}

variable "aws-region" {
  type        = string
  description = "AWS region in which resources are created"
  default     = "us-east-1"
}

variable "ami" {
  type        = string
  description = "AMI you want to create. ami-04505e74c0741db8d - Ubuntu. ami-0ed9277fb7eb570c9 - Amazon Linux 2."
  default     = "ami-04505e74c0741db8d"
}

variable "ami-type" {
  type        = string
  description = "AMI type you want to create"
  default     = "t2.micro"
}

variable "ssh-public-key" {
  type        = string
  description = "Public key for SSH access. Get from 'cat ~/.ssh/id_ed25519.pub'"
}
