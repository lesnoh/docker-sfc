#!/bin/bash
echo "Creating Flows on VM2 Bridge s2"
ovs-ofctl del-flows s2

echo "iperf redirect"
# from NF2 eth2 to iperf3 eth1
ovs-ofctl add-flow s2 priority=40090,in_port=3,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.4/32,actions=output:4
# from iperf3 eth1 to NF2 eth2
ovs-ofctl add-flow s2 priority=40080,in_port=4,ip,nw_src=192.168.1.4/32,nw_dst=192.168.1.1/32,actions=output:3
# from NF2 eth1 to VM1 via VxLAN VNI 42
ovs-ofctl add-flow s2 priority=40070,in_port=2,ip,nw_src=192.168.1.4/32,nw_dst=192.168.1.1/32,actions=set_field:42-\>tun_id,output:10
# from VM1 to NF2 eth1
ovs-ofctl add-flow s2 priority=40060,in_port=10,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.4/32,actions=output:2

echo "Adding L2 switch flow"
ovs-ofctl add-flow s2 action=normal
ovs-ofctl show s2
ovs-ofctl dump-flows s2
