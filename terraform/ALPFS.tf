# start ALPFS

resource "null_resource" "launch_alpfs"  {

depends_on = [
    aws_instance.alpfs
  ]

connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.alpfs.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "docker login --username ${var.docker_user} --password ${var.docker_access_token}",
      "docker pull ${var.docker_user}/${var.docker_repo}",
      "docker images",
      "docker run --name alpfs8080 -d -p 8080:8080 ${var.docker_user}/${var.docker_repo}",
      "docker logs alpfs8080"
    ]
  }
}