# Terraform AWS Security Group Component

Reusable Terraform child module that creates one AWS security group and optional IPv4 ingress rules. It uses dedicated `aws_vpc_security_group_ingress_rule` and `aws_vpc_security_group_egress_rule` resources, rather than mixing inline and standalone rules.

## What it creates

- `aws_security_group` in an existing VPC
- Zero or more named inbound IPv4 rules
- One allow-all outbound IPv4 rule, when enabled (default)

**Security default:** inbound traffic is completely blocked unless you set `ingress_rules`. By default, outbound IPv4 traffic is allowed; set `allow_all_egress = false` to disable it. This component manages IPv4 CIDR rules only.

## Requirements

- Terraform >= 1.13.5
- AWS provider >= 6.0.0 and < 7.0.0
- A pre-existing VPC (provide its ID)

## Usage example

```hcl
module "security_group" {
  source = "git::https://github.com/DmitriiPosturusu/tfcom-aws-security-group.git?ref=release/1.13.1.0"

  name   = "demo-ec2-sg"
  vpc_id = aws_vpc.example.id

  ingress_rules = {
    ssh = {
      description = "SSH from my workstation"
      cidr_ipv4   = "203.0.113.10/32" # Replace with your actual public IP/32
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
    }
  }

  tags = { Environment = "demo" }
}
```

A runnable example that creates its own VPC is in [`examples/basic`](examples/basic). Set `ssh_cidr` to your trusted address when applying it.

## Inputs

| Input | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | required | Security group name |
| `vpc_id` | `string` | required | Existing VPC ID |
| `description` | `string` | `"Managed by Terraform"` | Description |
| `ingress_rules` | `map(object)` | `{}` | Inbound IPv4 rules keyed by name |
| `allow_all_egress` | `bool` | `true` | Allow all outbound IPv4 |
| `tags` | `map(string)` | `{}` | Resource tags |

Each `ingress_rules` entry supports `cidr_ipv4` and `ip_protocol` plus optional `description`, `from_port`, and `to_port`. Ports are required for TCP/UDP; omit them when `ip_protocol = "-1"`.

## Outputs

- `security_group_id`
- `security_group_arn`
- `ingress_rule_ids`

## Run the example

```bash
cd examples/basic
terraform init
terraform plan -var='ssh_cidr=YOUR_PUBLIC_IP/32'
terraform apply -var='ssh_cidr=YOUR_PUBLIC_IP/32'
terraform destroy -var='ssh_cidr=YOUR_PUBLIC_IP/32'
```

Replace `YOUR_ORG` in the usage sample with the organization where you publish the repository. Use Git tags (for example, `v1.0.0`) to pin a release.
