#!/bin/bash

RELEASE=sfc:0.6

echo "Remove old containers"
docker stop Webserver1 && docker rm Webserver1
docker stop NF1 && docker rm NF1
docker stop Host1 && docker rm Host1

echo "Setup Portainer"
docker volume create portainer_data
docker run -d --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker start portainer

echo "Building container $RELEASE"
docker build . -t ${RELEASE}

echo "Start new containers"
docker run -it -d --name Host1 ${RELEASE} /bin/bash
docker run -it -d --privileged --name NF1 ${RELEASE} /bin/bash
docker run -d --name Webserver1 -p 8080:80 nginx

echo "The following containers are currently running on this system"
docker ps
