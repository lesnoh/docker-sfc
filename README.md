# Beschreibung

Docker SFC Versuchsaufbau mit zwei virtuellen Maschinen Open vSwitch.
Zwischen den VMs läuft über das Host-Only Netzwerk 192.168.56.0/24 ein VXLAN-Tunnel.

Für das Setup wird eine lokale VirtualBox [https://www.virtualbox.org/] Installation,
sowie das Provisionierungstool Vagrant [https://www.vagrantup.com/] benötigt.

## VM1

VM1 Host-Only IP enp0s8 192.168.56.21 (VxLAN Endpunkt VM1)

Auf VM1 laufen drei Docker Container:

- Host1		eth1: 192.168.1.1
- NF1		OVS br1 bestehend aus eth1, eth2
- Webserver1	eth1: 192.168.1.3

## VM2

VM2 Host-Only IP enp0s8 192.168.56.22 (VxLAN Endpunkt VM2)

Auf VM2 laufen drei Docker Container:


- Host2		eth1: 192.168.1.2
- NF2		OVS br1 bestehend aus eth1, eth2
- iperf3	eth1: 192.168.1.4

# Setup

Unter Umständen müssen die Shell-Skripte zunächst für den lokalen Benutzer ausführbar gemacht werden.

	git clone https://github.com/lesnoh/docker-sfc.git
	git checkout vxlan
	cd docker-sfc
	chmod u+x *.sh


VMs provisionieren und (neu)starten. Nach einem Neustart müssen die _magic_ Skripte neuausgeführt werden:

	vagrant up

VMs stoppen:

	vagrant halt

Demo löschen:

	vagrant destroy -f

VM Konsole

VM1:

	vagrant ssh docker-sfc-vm1

VM2:

	vagrant ssh docker-sfc-vm2

oder über VirtualBox GUI mit dem Login _vagrant_ und Passwort _vagrant_

## Docker:

Laufende Container auflisten:

	docker ps

Bash in einem laufenden Container ausführen:

	docker exec -it _containername_ /bin/bash


## OVS Dump:

	ovs-ofctl dump-flows s1

# Experiment

### VM1
	docker exec -it NF1 tcpdump -i eth1
	docker exec -it Host1 ping 192.168.1.3

#### Firewalltest:

	docker exec -it Host1 curl 192.168.1.3
	# Aufruf funktioniert, Firewallregel aktivieren
	# Zugriff testen und im Anschluss die Matches in der Flowtable anzeigen

	/docker-sfc/04-drop-http.sh
	docker exec -it Host1 curl 192.168.1.3
	docker exec -it NF1 ovs-ofctl dump-flows br0


#### Performancetests ohne Traffic-Shaping

	vagrant@docker-sfc-vm1:/docker-sfc docker exec -it Host1 iperf3 -c 192.168.1.4 -p 5201
	Connecting to host 192.168.1.4, port 5201
	[  4] local 192.168.1.1 port 40800 connected to 192.168.1.4 port 5201
	[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
	[  4]   0.00-1.00   sec   117 MBytes   978 Mbits/sec   49    474 KBytes


### Traffic Shaping
Traffic Shaping Versuchsaufbau um den Zugriff von Host1 auf iperf3 mittels NF2 zu begrenzen.

#### Kein Shaping (Host 1 auf VM1) <-> VXLAN <-> (NF2 VM2) <-> (iperf3 VM2)
VM2: ./13-createflows-NF2-noTrafficShaping.sh\
VM1:  iperf3 Client auf Container Host1 starten



	sudo docker exec -it Host1 iperf3 -c 192.168.1.4 -p 5201 -t 2
	Connecting to host 192.168.1.4, port 5201
	[  4] local 192.168.1.1 port 37218 connected to 192.168.1.4 port 5201
	[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
	[  4]   0.00-1.02   sec   133 MBytes  1.09 Gbits/sec  109    570 KBytes
	[  4]   1.02-2.00   sec   132 MBytes  1.13 Gbits/sec    0    712 KBytes
	[ ID] Interval           Transfer     Bandwidth       Retr
	[  4]   0.00-2.00   sec   265 MBytes  1.11 Gbits/sec  109             sender
	[  4]   0.00-2.00   sec   261 MBytes  1.10 Gbits/sec                  receiver

	iperf Done.


#### Vergleichstest innerhalb von VM2 von Host2 zu iperf3

	sudo docker exec -it Host2 iperf3 -c 192.168.1.4 -p 5201 -t 2


#### Shaping aktivieren (Host 1 auf VM1) <-> VXLAN <-> (NF2 VM2) <-> (iperf3 VM2)

VM2: ./13-createflows-NF2-TrafficShaping.sh\
VM1:  iperf3 Client auf Container Host1 starten

	sudo docker exec -it Host1 iperf3 -c 192.168.1.4 -p 5201 -t 2
	Connecting to host 192.168.1.4, port 5201
	[  4] local 192.168.1.1 port 37222 connected to 192.168.1.4 port 5201
	[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
	[  4]   0.00-1.00   sec  1.04 MBytes  8.67 Mbits/sec    0    108 KBytes
	[  4]   1.00-2.00   sec   126 KBytes  1.04 Mbits/sec    0    115 KBytes

	- - - - - - - - - - - - - - - - - - - - - - - - -

	[ ID] Interval           Transfer     Bandwidth       Retr
	[  4]   0.00-2.00   sec  1.16 MBytes  4.86 Mbits/sec    0             sender
	[  4]   0.00-2.00   sec   353 KBytes  1.44 Mbits/sec                  receiver

	iperf Done.
