#!/bin/bash

RELEASE=sfc:0.6

echo "Remove old containers"
sudo docker stop Webserver1 && sudo docker rm Webserver1
sudo docker stop NF1 && sudo docker rm NF1
sudo docker stop Host1 && sudo docker rm Host1

echo "Setup Portainer"
sudo docker volume create portainer_data
sudo docker run -d --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
sudo docker start portainer

echo "Building container $RELEASE"
sudo docker build . -t ${RELEASE}

echo "Start new containers"
sudo docker run -it -d --name Host1 ${RELEASE} /bin/bash
sudo docker run -it -d --privileged --name NF1 ${RELEASE} /bin/bash
sudo docker run -d --name Webserver1 -p 8080:80 nginx

echo "The following containers are currently running on this system"
sudo docker ps
