#! /usr/bin/python

from scapy.all import * #Forge packets
import netifaces #Manipulate interfaces
import netaddr   #Manipulate address
import os
import sys
from tools import *

def select_interface():
    all_interfaces = netifaces.interfaces()
    all_interfaces_reversed = reversed(all_interfaces)
    print(colors.CLEAR)
    for interface in all_interfaces_reversed:
        print("Please select an interface in the list:")
        print(str(all_interfaces))
        print(colors.BREVERSE+"--"+interface+"--"+colors.ENDC)
        answer = raw_input()
        print(colors.CLEAR)
        if answer == "y":
            return str(interface)
    #if the user has not made a choice
    return select_interface()
