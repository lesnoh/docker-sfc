#!/bin/bash

RELEASE=sfc:0.6

echo "Remove old containers"
docker stop NF2
docker rm NF2
docker stop Host2
docker rm Host2
docker stop iperf3 
docker rm iperf3

docker volume create portainer_data
docker run -d --name portainer -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
docker start portainer

echo "Building container $RELEASE"
docker build . -t ${RELEASE}

echo "Start new containers"
docker run -it -d --name Host2 ${RELEASE} /bin/bash
docker run -it -d --privileged --name NF2 ${RELEASE} /bin/bash
docker run -d --name iperf3 -p 5201:5201 networkstatic/iperf3 -s

echo "The following containers are currently running on this system"
docker ps