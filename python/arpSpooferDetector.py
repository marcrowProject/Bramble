#!/usr/bin/python

from scapy.all import *
import sys
from utils.network import *
from utils.tools import *
from time import sleep
import socket, struct
import sys

print colors.CLEAR

print colors.HEADER + "This tools allows you to detect a suspicious arp traffic.\n"\
+"If it detects something suspect it automatically stops itself \n"\
+"If you want to stop the process press ctrl-c." + colors.ENDC
print "Network analysis in progress..."

my_detector = Spoofer_Detector("result/scanNetwork/detection.txt",5)
my_detector.start()

try:
    while my_detector.is_running():
        sleep(5)
except KeyboardInterrupt:
    print("\nPlease wait...")
    print(colors.OKGREEN+"Stopping the process"+colors.ENDC)
    my_detector.join(2.0)#need to wait to stop the sniffing process and retrieve last packets

print(colors.OKGREEN + "Finished!" + colors.ENDC)
print("Press a button to quit.")
answer = raw_input()
