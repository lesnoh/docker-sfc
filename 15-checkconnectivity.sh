#!/bin/bash
echo -e "\nPing VM1 via enp0s8"
ping 192.168.56.21 -c 2

echo -e "\nPing Docker Container Host1 from Host2 via VXLAN"
sudo docker exec -it Host2 ip addr show dev eth1
sudo docker exec -it Host2 ping -c 2 192.168.1.1