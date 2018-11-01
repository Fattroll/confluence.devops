#!/bin/sh
apt-get install unzip
curl -fsSL https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip -o ~/
unzip ~/terraform_0.11.10_linux_amd64.zip -d ~/terraform/
export PATH=$PATH:~/terraform
