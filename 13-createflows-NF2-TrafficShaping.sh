#!/bin/bash

echo "Add OVS br0 in container NF2 and create flows.."
docker exec NF2 service openvswitch-switch start
docker exec NF2 ovs-vsctl del-br br0
docker exec NF2 ovs-vsctl add-br br0
docker exec NF2 ip link set dev br0 up

echo "Adding ports to bridge br0 and creating queues for traffic shaping"
docker exec NF2 ovs-vsctl add-port br0 eth1 -- \
set port eth1 qos=@newqos -- \
  --id=@newqos create qos type=linux-htb \
      other-config:max-rate=1000000000  \
      queues:123=@eth1queue -- \
  --id=@eth1queue create queue other-config:max-rate=1000000

docker exec NF2 ovs-vsctl add-port br0 eth2 -- \
set port eth2 qos=@newqos -- \
  --id=@newqos create qos type=linux-htb \
      other-config:max-rate=1000000000  \
      queues:234=@eth2queue -- \
  --id=@eth2queue create queue other-config:max-rate=1000000

docker exec NF2 ovs-ofctl del-flows br0
docker exec NF2 ovs-ofctl add-flow br0 in_port=2,ip,nw_src=192.168.1.4/32,nw_dst=192.168.1.1/32,actions=set_queue:123,output:1
docker exec NF2 ovs-ofctl add-flow br0 in_port=1,ip,nw_src=192.168.1.1/32,nw_dst=192.168.1.4/32,actions=set_queue:234,output:2

docker exec NF2 ovs-ofctl dump-flows br0