variable "aws_region" {
  type    = string
  default = "eu-west-1"
}

variable "ssh_cidr" {
  description = "Trusted public IPv4 CIDR for SSH, for example 203.0.113.10/32."
  type        = string
}
