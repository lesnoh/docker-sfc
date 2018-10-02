docker exec -it NF1 ovs-ofctl del-flows br0 ip,nw_src="192.168.1.1/32",tcp,tcp_dst=80
docker exec -it NF1 ovs-ofctl add-flow br0 priority=40000,ip,nw_src="192.168.1.1/32",tcp,tcp_dst=80,actions=drop
docker exec -it NF1 ovs-ofctl dump-flows br0
