#!/bin/bash

RELEASE=sfc:0.6

echo "Remove old containers"
sudo docker stop NF2
sudo docker rm NF2
sudo docker stop Host2
sudo docker rm Host2
sudo docker stop iperf3 
sudo docker rm iperf3

sudo docker volume create portainer_data
sudo docker run -d --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
sudo docker start portainer

echo "Building container $RELEASE"
sudo docker build . -t ${RELEASE}

echo "Start new containers"
sudo docker run -it -d --name Host2 ${RELEASE} /bin/bash
sudo docker run -it -d --privileged --name NF2 ${RELEASE} /bin/bash
sudo docker run -d --name iperf3 -p 5201:5201 networkstatic/iperf3 -s

echo "The following containers are currently running on this system"
sudo docker ps