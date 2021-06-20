# Create an AWS EC2 Instance with docker installed
# assumes linux ami

resource "aws_instance" "alpfs" {

  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name = aws_key_pair.generated_key.key_name
  security_groups = [ "${aws_security_group.allow_ALPFS_and_SSH.name}" ]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 16
    tags = {
      Name = "alpfs_root"
    }
  }

  tags = {
    Name = "ALPFS"
  }

  connection {
    type     = "ssh"
    user     = var.ami_user
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.alpfs.public_ip
  }

  provisioner "remote-exec" {
    inline = [
    "sudo groupadd docker",
    "sudo usermod -aG docker $USER",
    "sudo snap wait system seed.loaded",
    "sudo snap install docker"
    ]
  }

}

# Store the IP address in a local file
resource "null_resource" "write_public_ip"  {
	provisioner "local-exec" {
	    command = "echo  ${aws_instance.alpfs.public_ip} > publicip.txt"
	}
}
