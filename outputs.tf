output "security_group_id" {
  description = "ID of the created security group."
  value       = aws_security_group.this.id
}

output "security_group_arn" {
  description = "ARN of the created security group."
  value       = aws_security_group.this.arn
}

output "ingress_rule_ids" {
  description = "Map of ingress rule names to their AWS rule IDs."
  value       = { for name, rule in aws_vpc_security_group_ingress_rule.this : name => rule.security_group_rule_id }
}
