# ==== Create main VPC ====
resource "aws_vpc" "vpc_01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = "Main vpc"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

# ==== Internet Gateway ====
resource "aws_internet_gateway" "gw_01" {
  vpc_id = aws_vpc.vpc_01.id

  tags = {
    Name      = "Gateway_01"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

# ==== Create subnets for AZ 1 ====
resource "aws_subnet" "sub_01" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = var.az_01

  tags = {
    Name      = "Subnet_01"
    Owner     = local.owner_name
    Project   = local.tag_project
    AZ        = var.az_01
    Public    = true
    Terraform = true
  }
}

resource "aws_subnet" "sub_02" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = var.az_02

  tags = {
    Name      = "Subnet_02"
    Owner     = local.owner_name
    Project   = local.tag_project
    AZ        = var.az_02
    Public    = false
    Terraform = true
  }
}

# ==== Create subnets for AZ 2 ====

resource "aws_subnet" "sub_03" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = var.az_01

  tags = {
    Name      = "Subnet_03"
    Owner     = local.owner_name
    Project   = local.tag_project
    AZ        = var.az_01
    Public    = true
    Terraform = true
  }
}

resource "aws_subnet" "sub_04" {
  vpc_id            = aws_vpc.vpc_01.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = var.az_02

  tags = {
    Name      = "Subnet_04"
    Owner     = local.owner_name
    Project   = local.tag_project
    AZ        = var.az_02
    Public    = false
    Terraform = true
  }
}

# ==== Network routes and associations ====

# Route tables
resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_01.id

  # Local route
  route {
    cidr_block = aws_vpc.vpc_01.cidr_block
    gateway_id = "local"
  }

  # Public route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_01.id
  }

  tags = {
    Name      = "Public route table"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_01.id

  # Local route
  route {
    cidr_block = aws_vpc.vpc_01.cidr_block
    gateway_id = "local"
  }

  # Default route to the NAT Gatewas/Bastion host
  route {
     network_interface_id = aws_instance.bastion_host.primary_network_interface_id
     cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name      = "Private route table"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

# Route association

# Public subnets association
resource "aws_route_table_association" "sub_01_association" {
  subnet_id      = aws_subnet.sub_01.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "sub_03_association" {
  subnet_id      = aws_subnet.sub_03.id
  route_table_id = aws_route_table.route_table_public.id
}

# Private subnets association
resource "aws_route_table_association" "sub_02_association" {
  subnet_id      = aws_subnet.sub_02.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "sub_04_association" {
  subnet_id      = aws_subnet.sub_04.id
  route_table_id = aws_route_table.route_table_private.id
}
