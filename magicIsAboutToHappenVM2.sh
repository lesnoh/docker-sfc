#!/bin/bash

./10-setup-containers.sh
./11-ovs-bridge-ports.sh
./12-createflows.sh
./13-createflows-NF2-noTrafficShaping.sh
./15-checkconnectivity.sh
