#! /usr/bin/python

#sudo apt-get install python-netifaces python-netaddr
from scapy.all import * #Forge packets
from threading import Thread #Use thread for decoy scan
import netifaces #Manipulate interfaces
import netaddr   #Manipulate address
import random
import os
import sys
import argparse
from utils.network import *
from utils.tools import *


#-----------------------retrieve parameters-------------------------------------
#argparse tutorial : https://docs.python.org/3/howto/argparse.html

parser = argparse.ArgumentParser()
parser.add_argument("-o", "--output",
                    help="Output file,default=./result/scanNetwork/scanARP",
                    default="./result/scanNetwork/scanARP")
parser.add_argument("-d", "--decoy",
                    help="It doesn't hide your own IP, but it makes your IP one of a torrent of others supposedly scanning the victim at the same time",
                    action="store_true")
parser.add_argument("-v", "--verbose",
                    help="Verbosity, if set on 0 you have no information, on 1 you have info when it start and stop emission, on 2 when there is a response",
                    type=int, default=1)

args = parser.parse_args()

my_output = args.output

verbosity = args.verbose

my_interface = select_interface()

ip_list = arp_scan(my_interface,args.decoy,verbosity)

write_arp_scan_result(ip_list, my_output)
if verbosity > 0:
    answer = raw_input()
