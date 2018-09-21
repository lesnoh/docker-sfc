#!/bin/bash

ip_h1="192.168.1.1/32"
ip_w1="192.168.1.3/32"

dockercmd="sudo docker exec NF1 "

echo "OVS im Container starten"
$dockercmd service openvswitch-switch start
echo "Bridge löschen und neu anlegen"
$dockercmd ovs-vsctl del-br br0
$dockercmd ovs-vsctl add-br br0
$dockercmd ip link set br0 up
$dockercmd ovs-vsctl add-port br0 eth1
$dockercmd ovs-vsctl add-port br0 eth2
$dockercmd ovs-ofctl del-flows br0
echo "Flows erstellen"
$dockercmd ovs-ofctl add-flow br0 in_port=1,ip,nw_src=${ip_h1},nw_dst=${ip_w1},actions=output:2
$dockercmd ovs-ofctl add-flow br0 in_port=2,ip,nw_src=${ip_w1},nw_dst=${ip_h1},actions=output:1
$dockercmd ovs-ofctl show br0
$dockercmd ovs-ofctl dump-flows br0
