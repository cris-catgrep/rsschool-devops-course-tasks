# Creating AMI resource with Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Create Elastic IP for Bastion instance
resource "aws_eip" "eip_bastion" {
  domain = "vpc"
  instance = aws_instance.BastionHost.id
  depends_on = [aws_internet_gateway.gw_01]
}

# Creating VMs
resource "aws_instance" "BastionHost" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_01.id

  tags = {
    Name      = "Bastion Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

resource "aws_instance" "vm_sub_02" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_02.id

  tags = {
    Name      = "Subnet 02 Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

resource "aws_instance" "vm_sub_03" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_03.id

  tags = {
    Name      = "Subnet 03 Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

resource "aws_instance" "vm_sub_04" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_04.id

  tags = {
    Name      = "Subnet 04 Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}
