# ==== Security group for private subnets and rules ====

resource "aws_security_group" "sg_priv_sub" {
  name        = "sg_private_subnets"
  description = "Allows traffic only between AWS subnets"
  vpc_id      = aws_vpc.vpc_01.id

  tags = {
    Name = "sg_priv_sub"
    Owner = local.owner_name
    Project = local.tag_project
    Terraform = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_vpc_traffic" {
  security_group_id = aws_security_group.sg_priv_sub.id
  cidr_ipv4         = aws_vpc.vpc_01.cidr_block
  from_port         = -1
  ip_protocol       = "-1"
  to_port           = -1
  description = "Allow all traffic from vpc_01"

  tags = {
    Name = "allow_vpc_traffic"
    Owner = local.owner_name
    Project = local.tag_project
    Terraform = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_bastion" {

  security_group_id = aws_security_group.sg_priv_sub.id
  cidr_ipv4         = "${var.bastion_priv_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  description = "Allow ssh connections from Bastion host"

  tags = {
    Name = "allow_ssh_bastion"
    Owner = local.owner_name
    Project = local.tag_project
    Terraform = true
  }
}

# ==== Security group for public subnets and rules ====

