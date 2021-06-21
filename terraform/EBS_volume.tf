# Create EBS volumes and Attach to EC2 Instance

# warning: /dev/xvdh is not designed to persist. best use case: partition for logs

# /dev/sdh

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
  # TODO encrypted = true?

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

# /dev/sdf

# This idea is to have existing persistent storage and attach to it, but
# this fails if the new instance is not in the same availabilty zone as the storage
# but this has no contorl over that yet. and a copy in each zone seems excessive.

# TODO create separate task to attch after zone is known?

# persistent storage of an existing volume created with web ui atm. todo with terraform. conditionals?
# needs volume id from envvar


# resource "aws_volume_attachment" "alpfs_persistore" {
#   device_name  = "/dev/sdf"
#   volume_id    = var.ebs_volume_id
#   instance_id  = aws_instance.alpfs.id
#   force_detach = true
# 
#   # TODO availablity zone? multiple creations in each zone?
#   # availability_zone = aws_instance.alpfs.availability_zone
# 
# }
# 
# 
# resource "null_resource" "MountALPFSPersistore"  {
# 
#   depends_on = [
#     aws_volume_attachment.alpfs_persistore,
#   ]
# 
#   connection {
#     type     = "ssh"
#     user     = var.ami_user
#     private_key = tls_private_key.createkey.private_key_pem
#     host     = aws_instance.alpfs.public_ip
#   }
# 
#   provisioner "remote-exec" {
#     inline = [
#       # todo via terraform, first time only "sudo mkfs -t xfs /dev/xvdf",
#       "sudo mkdir /mnt/sdf",
#       "sudo chown ubuntu:ubuntu /mnt/sdf",
#       "sudo mount /dev/xvdf /mnt/sdf",
#       "cd /mnt/sdf && ls",
#     ]
#   }
# 
# }
#
