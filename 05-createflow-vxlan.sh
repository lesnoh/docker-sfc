#!/bin/bash

echo "VXLAN Tunnel und Flows erstellen"
ovs-vsctl add-port s1 vxlan1 -- set interface vxlan1 type=vxlan option:remote_ip=192.168.56.22 option:key=flow ofport_request=10
ovs-ofctl add-flow s1 in_port=1,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.2/32,actions=output:2
ovs-ofctl add-flow s1 in_port=2,ip,nw_src=192.168.1.2/32,nw_dst=192.168.1.1/32,actions=output:1
ovs-ofctl add-flow s1 in_port=3,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.2/32,actions=set_field:42-\>tun_id,output:10
ovs-ofctl add-flow s1 in_port=10,ip,nw_src=192.168.1.2/32,nw_dst=192.168.1.1/32,tun_id=42,actions=output:3
sudo docker exec NF1 ovs-ofctl add-flow br0 in_port=1,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.2/32,actions=output:2
sudo docker exec NF1 ovs-ofctl add-flow br0 in_port=2,ip,nw_src=192.168.1.2/32,nw_dst=192.168.1.1/32,actions=output:1

ovs-ofctl dump-flows s1