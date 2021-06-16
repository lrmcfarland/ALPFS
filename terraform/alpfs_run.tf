# docker run image

resource "null_resource" "alpfs_docker_run"  {

depends_on = [
    "null_resource.alpfs_docker_pull"
  ]

connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = tls_private_key.createkey.private_key_pem
    host     = aws_instance.alpfs.public_ip
  }

provisioner "remote-exec" {
    inline = [
      "docker run --name alpfs8080 -d -p 8080:8080 ${var.docker_user}/${var.docker_repo}",
      "docker logs alpfs8080"
    ]
  }
}