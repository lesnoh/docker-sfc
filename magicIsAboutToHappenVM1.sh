#!/bin/bash

sudo ./00-setup-containers.sh
sudo ovs-ofctl del-flows s1
sudo ./01-ovs-bridge-ports.sh
echo "Ping with normal switch operation from 192.168.1.1 to 192.168.1.3"
sudo docker exec -it Host1 ping 192.168.1.3 -c 2
sudo ./02-createflows.sh
sudo ./03-createflows-NF1.sh
echo "Ping with flows redirection traffic through NF1 from 192.168.1.1 to 192.168.1.3"
sudo docker exec -it Host1 ping 192.168.1.3 -c 2
sudo ./05-createflow-vxlan.sh