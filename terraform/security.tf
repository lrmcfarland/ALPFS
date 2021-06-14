# ALPFS from starbug.com

provider "aws" {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
    region = "us-west-1"
}

# Create a key_pair for SSH in AWS instance

resource "tls_private_key" "createkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "alpfs_key"
  public_key = tls_private_key.createkey.public_key_openssh
}

resource "null_resource" "savekey"  {
  depends_on = [
    tls_private_key.createkey,
  ]
	provisioner "local-exec" {
	    command = "echo  '${tls_private_key.createkey.private_key_pem}' > alpfs_key.pem"
	}
}

# Create ALPFS Security Group
resource "aws_security_group" "allow_ALPFS_and_SSH" {
  name        = "allow_ALPFS_and_SSH"
  description = "Allow ALPFS and ssh inbound traffic"
  # allow ingress of port 80
  ingress {
    description = "Allow HTTP ALPFS"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # allow ingress of port 22
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ALPFS"
  }
}
