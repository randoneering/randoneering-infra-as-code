locals {
  vpc_id = lookup(var.vpc_id, var.environment, "vpc-not-found")
  engine = {
    postgres = "5432"
    mysql    = "3306"
  }
}


data "aws_ec2_managed_prefix_list" "rfc_1918" {
  name = "RFC 1918"
}


resource "aws_security_group" "default" {
  for_each    = local.engine
  name        = "db_${each.key}_default"
  description = "Allow communication via ${each.key} default port ${each.value}"
  vpc_id      = local.vpc_id

  tags = merge(var.required_tags, var.resource_tags)
}


resource "aws_vpc_security_group_ingress_rule" "inbound" {
  for_each          = local.engine
  security_group_id = aws_security_group.default[each.key].id
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  prefix_list_id    = data.aws_ec2_managed_prefix_list.rfc_1918.id
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
  for_each          = aws_security_group.default
  security_group_id = aws_security_group.default[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
