sudo docker exec -it NF1 ovs-ofctl del-flows br0 ip,nw_src="192.168.1.1/32",tcp,tcp_dst=80
sudo docker exec -it NF1 ovs-ofctl dump-flows br0
