#!/usr/bin/python

from scapy.all import *
import sys
from utils.network import *
from utils.tools import *
from time import sleep
import socket, struct
import argparse
import signal
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
    #my_detector.stop()
    my_detector.join(2.0)
    #if my_detector.isAlive():
    #    my_detector.socket.close()
print(colors.OKGREEN + "Finished!" + colors.ENDC)
print("Press a button to quit.")
answer = raw_input()


"""
try:
    output = open("result/scanNetwork/spoofing_Detector_Report.txt","w")
except IOError:
    print(colors.FAIL+"\nWe can't save the result"+colors.ENDC)
    print(colors.WARNING+"May be the directory doesn't exist")
    print("But it's pretty sure your output path is wrong"+colors.ENDC)
    print(colors.HEADER+"Use -o 'your_path' to change the output"+colors.ENDC)
    print("\n\n\t"+colors.FAIL+"Failed."+colors.ENDC+" Press a button to quit")
    exit()
except:
    print(+colors.FAIL+"A problem occured"+colors.ENDC)
    exit()

beginning =  time.time()
print("start at : "+time.asctime( time.localtime(beginning)))
output.write("started at : "+time.asctime( time.localtime(beginning))+"\n")
try:
    ans = sniff(filter="arp", count=100, prn=None, lfilter=None, timeout=5, iface="wlan0")
except KeyboardInterrupt:
    print("stopped")
    print ans
end = time.time()
my_list = []
for packet in ans:
    for arp in packet:
        my_list.append(str(arp.psrc))
my_set = set(my_list)
total_time = end - beginning

for packet in my_set:
    nb_pck = str(my_list.count(packet))
    result_color = colors.OKGREEN  if int(nb_pck)/total_time<1 else colors.FAIL
    line = result_color + nb_pck + colors.ENDC + " packets from : " + result_color + packet + colors.ENDC
    print line
    output.write(line+"\n")

print("ended at : "+time.asctime( time.localtime(end)))
output.write("ended at : "+time.asctime( time.localtime(end))+"\n")
print("save in result/scanNetwork/spoofing_Detector_Report.txt")
output.close
"""
