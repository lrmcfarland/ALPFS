# Terraform

This repo demonstraits how to deploy the Alpine Linux Python Flask
Server to AWS using terraform.

# To Install

## On OSX


If you have not already done so

```
brew install terraform

```


# Credentials

This example uses access tokens to access my AWS and DockerHub accounts.

## AWS API user

Create an IAM API terraform user in the Users control panel of the
[AWS IAM dashboard](https://console.aws.amazon.com/iam/home#/home) for
your account.  [Create a terraform AWS API
user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_api)
account with programmatic access only.  In that account, create an
access key and make a note of the access key and secret key.


References:

- [Managing access keys for IAM users](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html)
- [How to create an IAM account and configure Terraform to use AWS static credentials?](https://gmusumeci.medium.com/how-to-create-an-iam-account-and-configure-terraform-to-use-aws-static-credentials-a8ea4dd4fdfc)


## DockerHub Access Token

Similarly, create an access token for your DockerHub account in your [security panel](https://hub.docker.com/settings/security).

```
TODO

WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /home/ubuntu/snap/docker/796/.docker/config.json.

```


# To configure

You will need to pick an Amazon Machine Image (AMI) appropriate for your region.
At the moment, I have this hard-coded in [EC2_instance.tf](EC2_instance.tf) to
ami-0d382e80be7ffdae5 for my 2021 us-west-1 region.
This will also implicitly select your package manager, i.e. yum for RHEL
and apt-get for Debian distributions.
In this example I used snap to install docker and found
`snap wait system seed.loaded` necessary to avoid startup
race conditions (see [EC2_instance.tf](EC2_instance.tf))
Also this choice may affect your connection user, i.e. may be 'ubuntu' instead of 'ec2-user'
when connecting in [EC2_instance.tf](EC2_instance.tf) or [ALPFS.tf](ALPFS.tf).


## variables.tf

The above information is collected in [variables.tf](variables.tf) either by prompting
when run or from TF_VAR environemnt variables.

```
#!/usr/bin/env zsh

export TF_VAR_aws_access_key=<aws access key>
export TF_VAR_aws_secret_key=<aws secret key>

export TF_VAR_docker_repo=<container to deploy, e.g. "alpfs">
export TF_VAR_docker_user=<docker user, e.g. lrmcfarland>
export TF_VAR_docker_access_token=<docker access token>

```


### AWS Access key

AWS access key generaged above.

### AWS Secret key

AWS secret key generaged above.


### Docker Repo

Docker repo/image to deploy. This must match the docker tag applied above.
It will expand as `<docker user>/<docker repo>` to do the docker pull.


### Docker User

Docker user's repo.

### Docker Access Token

Docker API access token for user's repo.

```
TODO

WARNING! Using --password via the CLI is insecure. Use --password-stdin.
WARNING! Your password will be stored unencrypted in /home/ubuntu/snap/docker/796/.docker/config.json.

```

# To initialize

In the ALPFS/terraform directory


```
terraform init

```



# To apply


```
terraform apply

```

You should see the instance come up on your EC2 dashboard with the public IP and FQDN.
You should also be able to see the home page on the public IP or FQDN, port 8080.

In this case [http://ec2-54-176-39-221.us-west-1.compute.amazonaws.com:8080](http://ec2-54-176-39-221.us-west-1.compute.amazonaws.com:8080)

Note: this will change each time it is launched.


## SSH

These scripts will output two files to the local directory: alpfs_key.pem and publicip.txt.
These contain the private key and public IP of the instance if successful.
To use the alpfs_key.pem file you will need to change the permissions, but if you
change the permissions of this file to read only, the next build will fail when it
trys to overwrite it. I found using a copy to be helpful.


```
rm -f true_alpfs_key.pem
cp alpfs_key.pem true_alpfs_key.pem
chmod 400 true_alpfs_key.pem
ssh -i true_alpfs_key.pem ubuntu@`cat publicip.txt`

```

```
Welcome to Ubuntu 20.04.2 LTS (GNU/Linux 5.4.0-1045-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jun 14 17:40:46 UTC 2021

  System load:  0.03              Processes:                105
  Usage of /:   19.0% of 7.69GB   Users logged in:          0
  Memory usage: 32%               IPv4 address for docker0: 172.17.0.1
  Swap usage:   0%                IPv4 address for eth0:    172.31.16.128


1 update can be applied immediately.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Mon Jun 14 17:39:47 2021 from 73.158.190.51
ubuntu@ip-172-31-16-128:~$

ubuntu@ip-172-31-17-30:~$ docker ps -a
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                            NAMES
2dc54f654de4        lrmcfarland/alpfs   "python alpfs.py -p …"   11 minutes ago      Up 11 minutes       80/tcp, 0.0.0.0:8080->8080/tcp   alpfs8080



```

# To destroy



```
terraform destroy

```


