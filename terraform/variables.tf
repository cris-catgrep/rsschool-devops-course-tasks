variable "credentials" {
  default = ["~/.aws/credentials"]
}

variable "region" {
  default = "us-east-2"
}

variable "az_01" {
  default = "us-east-2a"
}

variable "az_02" {
  default = "us-east-2b"
}

variable "bastion_priv_ip" {
  default = "10.0.10.10"
}

variable "vm_sub_02_priv_ip" {
  default = "10.0.11.10"
}

variable "vm_sub_03_priv_ip" {
  default = "10.0.12.10"
}

variable "vm_sub_04_priv_ip" {
  default = "10.0.13.10"
}

# Home IP, change depending on location
variable "home_ip" {
  default = "200.68.167.14"
}

variable "public-key-path" {
  type = string
  default = "ssh/ec2-bastion.pub"
}
variable "private-key-path" {
  type = string
  default = "ssh/ec2-bastion.pem"
}
variable "key-nam" {
  default = "ec2-bastion"
}
