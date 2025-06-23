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
  instance = aws_instance.bastion_host.id
  depends_on = [aws_internet_gateway.gw_01]
}

# Creating VMs
resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.amazon_linux_2.id
  source_dest_check = false
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_01.id
  private_ip = var.bastion_priv_ip
  key_name = aws_key_pair.ssh_key_pair.key_name
  user_data = <<-EOF
	# Turning on IP Forwarding
	echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
	sudo sysctl -p

	# Making a catchall rule for routing and masking the private IP
	sudo iptables -t nat -A POSTROUTING -o ens5 -s 0.0.0.0/0 -j MASQUERADE
	EOF

  tags = {
    Name      = "Bastion and NAT Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}

resource "aws_instance" "vm_sub_02" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.sub_02.id
  private_ip = var.vm_sub_02_priv_ip

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
  private_ip = var.vm_sub_03_priv_ip

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
  private_ip = var.vm_sub_04_priv_ip

  tags = {
    Name      = "Subnet 04 Host"
    Owner     = local.owner_name
    Project   = local.tag_project
    Terraform = true
  }
}
