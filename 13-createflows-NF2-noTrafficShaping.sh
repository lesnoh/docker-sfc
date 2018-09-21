#!/bin/bash

echo "Add OVS br0 in container NF2 and create flows.."
sudo docker exec NF2 service openvswitch-switch start
sudo docker exec NF2 ovs-vsctl del-br br0
sudo docker exec NF2 ovs-vsctl add-br br0
sudo docker exec NF2 ip link set dev br0 up
sudo docker exec NF2 ovs-vsctl add-port br0 eth1
sudo docker exec NF2 ovs-vsctl add-port br0 eth2
sudo docker exec NF2 ovs-ofctl del-flows br0

sudo docker exec NF2 ovs-ofctl add-flow br0 in_port=2,ip,nw_src=192.168.1.4/32,nw_dst=192.168.1.1/32,actions=output:1
sudo docker exec NF2 ovs-ofctl add-flow br0 in_port=1,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.4/32,actions=output:2

sudo docker exec NF2 ovs-ofctl dump-flows br0