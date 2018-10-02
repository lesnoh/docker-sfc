#!/bin/bash

./00-setup-containers.sh
ovs-ofctl del-flows s1
./01-ovs-bridge-ports.sh
echo "Ping with normal switch operation from 192.168.1.1 to 192.168.1.3"
docker exec -it Host1 ping 192.168.1.3 -c 2
./02-createflows.sh
./03-createflows-NF1.sh
echo "Ping with flows redirection traffic through NF1 from 192.168.1.1 to 192.168.1.3"
docker exec -it Host1 ping 192.168.1.3 -c 2
./05-createflow-vxlan.sh