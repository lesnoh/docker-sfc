#!/bin/bash

ip_h1="192.168.1.1/32"
ip_w1="192.168.1.3/32"

echo "Creating Flows on VM1 Bridge s1"

ovs-ofctl del-flows s1
ovs-ofctl add-flow s1 in_port=1,ip,nw_src=${ip_h1},nw_dst=${ip_w1},actions=output:2
ovs-ofctl add-flow s1 in_port=3,ip,nw_src=${ip_h1},nw_dst=${ip_w1},actions=output:4
ovs-ofctl add-flow s1 in_port=4,ip,nw_src=${ip_w1},nw_dst=${ip_h1},actions=output:3
ovs-ofctl add-flow s1 in_port=2,ip,nw_src=${ip_w1},nw_dst=${ip_h1},actions=output:1

echo "Adding L2 switch flow"
ovs-ofctl add-flow s1 action=normal
ovs-ofctl show s1
ovs-ofctl dump-flows s1