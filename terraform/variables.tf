# read secrets from exported by environment variables in user's current shell


variable "aws_ami" {
  description = "AWS Amazon Machine Image"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS Instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_user" {
  description = "AWS AMI user"
  type        = string
  default     = "ubuntu"
}


variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "docker_repo" {
  description = "docker repo"
  type        = string
}

variable "docker_user" {
  description = "docker user"
  type        = string
}

# # TODO WARNING! Your password will be stored unencrypted in /home/ubuntu/snap/docker/
variable "docker_access_token" {
  description = "docker access token"
  type        = string
}
