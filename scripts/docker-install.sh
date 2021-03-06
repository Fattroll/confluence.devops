#!/bin/sh

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/debian \
		$(lsb_release -cs) \
	         stable"
sudo apt-get update
sudo apt-get -y install docker-ce
selfwar=$(whoami)
sudo gpasswd -a $selfwar docker
