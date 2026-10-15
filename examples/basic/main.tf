provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "example" {
  cidr_block = "10.30.0.0/16"

  tags = { Name = "sg-example-vpc" }
}

module "security_group" {
  source = "../.."

  name   = "example-ec2-sg"
  vpc_id = aws_vpc.example.id

  ingress_rules = {
    # Restrict this to your own public IP; do not use 0.0.0.0/0 for SSH.
    ssh = {
      description = "SSH from trusted workstation"
      cidr_ipv4   = var.ssh_cidr
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }
  }

  tags = { Environment = "demo" }
}

output "security_group_id" {
  value = module.security_group.security_group_id
}
