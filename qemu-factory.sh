#!/bin/bash

bridge=br0
tap=$(sudo /sbin/tunctl -u $(whoami) -b)

# start the network bridge

sudo /sbin/brctl addbr $bridge
sleep 1s
sudo ip link set $tap up
sleep 1s
sudo /sbin/brctl addif $bridge $tap

# start the virtual machine

qemu-kvm -m 768 -cpu core2duo \
-net nic,vlan=0,macaddr=00:16:AB:CD:EF:00 \
-net tap,vlan=0,ifname=$tap,script=no,downscript=no \
-hda /home/ryko/.libvirt/images/opensuse-factory/opensuse-factory.qcow2 \
-hdb /home/ryko/.libvirt/images/opensuse-factory/opensuse-swap.qcow2

# stop the network bridge

sudo /sbin/brctl delif $bridge $tap
sudo ip link set $tap down
sudo /sbin/tunctl -d $tap
sudo /sbin/brctl delbr $bridge
