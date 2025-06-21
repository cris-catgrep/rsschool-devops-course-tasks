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
