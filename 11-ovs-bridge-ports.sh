#!/bin/bash
echo "Stopping old containers and delete Bridge s2"

docker stop Host2 NF2 iperf3
ovs-vsctl del-br s2
ovs-vsctl add-br s2

echo "Restarting Containers"
docker start Host2 NF2 iperf3
sleep 5

echo "Connect containers to Bridge s1"
ovs-vsctl add-port s2 vxlan2 -- set interface vxlan2 type=vxlan option:remote_ip=192.168.56.21 option:key=flow ofport_request=10
ovs-docker add-port s2 eth1 Host2 --ipaddress=192.168.1.2/24 --macaddress="00:00:00:02:00:02" --mtu=1450
ovs-docker add-port s2 eth1 NF2 --macaddress="00:00:00:02:11:01" --mtu=1450
ovs-docker add-port s2 eth2 NF2 --macaddress="00:00:00:02:11:02" --mtu=1450
ovs-docker add-port s2 eth1 iperf3 --ipaddress=192.168.1.4/24 --macaddress="00:00:00:02:22:01" --mtu=1450
