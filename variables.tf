variable "name" {
  description = "Name of the security group."
  type        = string
}

variable "description" {
  description = "Description of the security group."
  type        = string
  default     = "Managed by Terraform"
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created."
  type        = string
}

variable "ingress_rules" {
  description = "Map of inbound IPv4 CIDR rules. Empty by default (no inbound access)."
  type = map(object({
    description = optional(string)
    cidr_ipv4   = string
    ip_protocol = string
    from_port   = optional(number)
    to_port     = optional(number)
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      rule.ip_protocol == "-1" ?
      (rule.from_port == null && rule.to_port == null) :
      (rule.from_port != null && rule.to_port != null)
    ])
    error_message = "For ip_protocol '-1', omit ports; otherwise, provide from_port and to_port."
  }
}

variable "allow_all_egress" {
  description = "Whether to allow all outbound IPv4 traffic."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional resource tags. Name is set by the module."
  type        = map(string)
  default     = {}
}
