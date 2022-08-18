terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider

provider "aws" {
  region = var.region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Creates a firewall and opens port 80

resource "aws_security_group" "nginx" {
  name        = "nginx_firewall"
  description = "Firewall for the nginx-server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creates the EC2 instance and runs the nginx.sh file on startup

resource "aws_instance" "nginx_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  user_data = file("./modules/webserver/nginx.sh")

  security_groups = [aws_security_group.nginx.name]
  
  tags = {
    Name = "${var.student_alias}_nginx_server"
  }
}

output "instance_public_ip" {
  value = aws_instance.nginx_server.public_ip
}