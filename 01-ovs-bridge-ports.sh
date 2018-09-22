#!/bin/bash
echo "Stopping old containers and delete Bridge s1"
docker stop Host1 Webserver1 NF1
ovs-vsctl del-br s1
ovs-vsctl add-br s1

echo "Restarting containers"
docker start Host1 Webserver1 NF1
sleep 5

echo "Connect containers to Bridge s1"
ovs-docker add-port s1 eth1 Host1 --ipaddress=192.168.1.1/24 --macaddress="00:00:00:01:00:01" --mtu=1450
ovs-docker add-port s1 eth1 NF1 --macaddress="00:00:00:01:11:01" --mtu=1450
ovs-docker add-port s1 eth2 NF1 --macaddress="00:00:00:01:11:02" --mtu=1450
ovs-docker add-port s1 eth1 Webserver1 --ipaddress=192.168.1.3/24 --macaddress="00:00:00:00:22:01" --mtu=1450
