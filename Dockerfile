#SFC with OVS and tcpdump Container
FROM ubuntu:18.04
MAINTAINER Michael Honsel (lesnoh@gmx.de)

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install net-tools iputils-ping curl tcpdump iproute2 openvswitch-common openvswitch-switch iperf3 -y
RUN apt-get clean
CMD ["echo","Image created"]
