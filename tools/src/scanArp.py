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

class Decoy(Thread):
    def __init__(self, fakeIp, targetList, interface):
        Thread.__init__(self)
        self.fakeIp = fakeIp
        self.targetList = targetList
        self.interface = interface

    def run(self):
        send(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = self.targetList, psrc=self.fakeIp), iface=self.interface, verbose=0)



class colors: #Add colors in terminal
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'        #Come back to the initial color
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    BREVERSE = '\033[7;1m'  #Used to put in the light the current item
    CLEAR = "\033[H\033[2J" #Clear the screen

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

#-----------------------Select the interface------------------------------------
all_interfaces = netifaces.interfaces()
all_interfaces_reversed = reversed(all_interfaces)
print(colors.CLEAR)
my_interface=""
answer="n"
while answer != "y":
    for interface in all_interfaces_reversed:
        print("Please select an interface in the list:")
        print(str(all_interfaces))
        print(colors.BREVERSE+"--"+interface+"--"+colors.ENDC)
        answer = raw_input()
        print(colors.CLEAR)
        if answer == "y":
            my_interface = str(interface)
            break

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
if args.decoy:
    if verbosity > 0:
        print("send a first decoy")
    fake = random.randint(0,len(addr_list))
    thread_1 = Decoy(str(fake), addr_list, my_interface)
    thread_1.start()
    thread_1.join()
    time.sleep(0.3)
#send&receive packets for the arp scan
ans, unans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = addr_list), timeout=1, iface=my_interface, verbose=verbosity) #retry=2
#-----------------------------Save the result------------------------------------------
try:
    my_file = open(my_output, "w")
    nb_decoy=3 # limit the number of decoys

    for snd, rcv in ans:
        his_ip = rcv.sprintf(r"%Ether.psrc%")
        his_mac = rcv.sprintf(r"%Ether.src%")
        thread_1 = Decoy(str(his_ip), addr_list, my_interface)
        if args.decoy and nb_decoy > 0:
            thread_1.start()
        info = socket.gethostbyaddr(his_ip)
        his_hostname = str(info[0])
        if verbosity > 0:
            print(his_mac+" - "+his_ip+" - "+his_hostname)
        my_file.write(his_ip)
        my_file.write("\n")
        if args.decoy and nb_decoy > 0:
            thread_1.join()
            nb_decoy -= 1

    if verbosity > 0:
        print(colors.OKGREEN+"\nIt's done."+colors.ENDC+" Press a button to quit")
except IOError:
    print(colors.FAIL+"\nWe can't save the result in "+my_output+colors.ENDC)
    print(colors.WARNING+"May be the directory doesn't exist")
    print("But it's pretty sure your output path is wrong"+colors.ENDC)
    print(colors.HEADER+"Use -o 'your_path' to change the output"+colors.ENDC)
    print("\n\n\t"+colors.FAIL+"Failed."+colors.ENDC+" Press a button to quit")
except:
    print(+colors.FAIL+"A problem occured"+colors.ENDC)
if verbosity > 0:
    answer = raw_input()
