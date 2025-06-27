# Generate SSH key for Bastion host
resource "tls_private_key" "bastion_ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Create the file for Public Key
resource "local_file" "public_key" {
  depends_on = [ tls_private_key.bastion_ssh_key ]
  content = tls_private_key.bastion_ssh_key.public_key_openssh
  filename = var.public-key-path
}

# Create the sensitive file for Private Key
resource "local_sensitive_file" "bastion_private_key" {
  depends_on = [ tls_private_key.bastion_ssh_key ]
  content = tls_private_key.bastion_ssh_key.private_key_pem
  filename = var.private-key-path
  file_permission = "0600"
}

## AWS SSH Key Pair
resource "aws_key_pair" "ssh_key_pair" {
  depends_on = [ local_file.public_key ]
  key_name = var.key-nam
  public_key = tls_private_key.bastion_ssh_key.public_key_openssh
}
