provider "aws" {
  region     = var.aws-region
}

terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
  }
}

resource "aws_instance" "public" {
  ami              = "${var.ami}"
  instance_type    = "${var.ami-type}"
  //count            = 1
  associate_public_ip_address = true

  key_name         = "ssh-key"
  vpc_security_group_ids = [aws_security_group.main.id]

  user_data = <<EOF
#!/bin/bash -v
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -a -G docker ubuntu
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo apt upgrade -y
EOF

  tags = {
    Name = "${var.name}-${var.environment}"
  }
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  }
  ]
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "${var.ssh-public-key}"
}

output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.public.public_ip
}