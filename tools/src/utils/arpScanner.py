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
import time
from utils.network import *
from utils.tools import *

class Decoy(Thread):
    def __init__(self, fakeIp, targetList, interface):
        Thread.__init__(self)
        self.fakeIp = fakeIp
        self.targetList = targetList
        self.interface = interface

    def run(self):
        send(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = self.targetList, psrc=self.fakeIp), iface=self.interface, verbose=0)



def arp_scan(my_interface, decoy=False, verbosity=0):
    #-----------------------Take info about the network-----------------------------
    ip = netifaces.ifaddresses(my_interface)[2][0]['addr']
    netmask = netifaces.ifaddresses(my_interface)[2][0]['netmask']

    netaddr_ip = netaddr.IPAddress(ip)
    netaddr_netmask = netaddr.IPAddress(netmask)
    netaddr_network = netaddr_ip & netaddr_netmask

    netaddr_full_network = netaddr.IPNetwork(str(netaddr_ip) + '/' + str(netaddr_netmask))
    netaddr_list = netaddr.IPRange(netaddr_network, netaddr_full_network[-2])

    #Create a list sr compatible to avoid to use sr in a loop
    addr_list = []
    for address in netaddr_list:
        addr_list.append(str(address))

    #-----------------------------ARP scan------------------------------------------
    #Start the ARP scan
    if verbosity > 0:
        print(colors.OKGREEN+"Be patient that can take a while."+colors.ENDC)
    #send a first random decoy scan if u use the option
    if decoy:
        if verbosity > 0:
            print("send a first decoy")
        fake = random.randint(0,len(addr_list))
        thread_1 = Decoy(str(fake), addr_list, my_interface)
        thread_1.start()
        thread_1.join()
        time.sleep(0.2)
    #send&receive packets for the arp scan
    ans, unans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = addr_list), timeout=1, iface=my_interface, verbose=verbosity, retry=1) #retry=2
    #-----------------------------Save the result------------------------------------------
    nb_decoy=3 # limit the number of decoys
    threads_list = []
    ip_list = []
    for snd, rcv in ans:
        his_ip = rcv.sprintf(r"%Ether.psrc%")
        his_mac = rcv.sprintf(r"%Ether.src%")
        ip_list.append(his_ip)
        if decoy and nb_decoy > 0:
            my_thread = Decoy(str(his_ip), addr_list, my_interface)
            my_thread.start()
            threads_list.append(my_thread)
            nb_decoy -= 1
        try:
            info = socket.gethostbyaddr(his_ip)
            his_hostname = str(info[0])
            if verbosity > 0:
                print(his_mac+" - "+his_ip+" - "+his_hostname)
        except:
            print(his_mac+" - "+his_ip)
    if verbosity > 0:
        print(colors.OKGREEN+"\nIt's done."+colors.ENDC+" Press a button to quit")
    for current in threads_list:
        current.join()
    return ip_list
