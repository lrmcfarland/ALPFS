# Create EBS volumes and Attach to EC2 Instance

# warning: /dev/xvdh is not designed to persist. best use case: partition for logs

# TODO store already created and has snapshot_id and not destroyed
# TODO snapshot_id = "snap-073cb7ab26e8050be" pre created
# TODO encrypted = true?


# created, formated and destroyed with instance
resource "aws_ebs_volume" "alpfs_devsdh" {

  availability_zone = aws_instance.alpfs.availability_zone
  size = 4
  type = "gp2"
  tags = {
    Name = "alpfs_devsdh"
  }

}

resource "aws_volume_attachment" "attach_devsdh" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.alpfs_devsdh.id
  instance_id = aws_instance.alpfs.id

  force_detach = true
  # TODO skip_destroy = true
  # TODO delete_on_termination = false
}

resource "null_resource" "MountDevSdh"  {

  depends_on = [
    aws_volume_attachment.attach_devsdh,
  ]

  connection {
    type     = "ssh"
    user     = var.ami_user
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.alpfs.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t xfs /dev/xvdh",
      "sudo mkdir /mnt/sdh",
      "sudo mount /dev/xvdh /mnt/sdh",
      "sudo chown ubuntu:ubuntu /mnt/sdh",
      "cd /mnt/sdh && ls",
    ]
  }

}