#!/bin/bash

sudo ./10-setup-containers.sh
sudo ./11-ovs-bridge-ports.sh
sudo ./12-createflows.sh
sudo ./13-createflows-NF2-noTrafficShaping.sh
sudo ./15-checkconnectivity.sh
