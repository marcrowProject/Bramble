#!/usr/bin/python

from scapy.all import *
import sys
from utils.network import *
from utils.tools import *
import socket, struct
import argparse

detect_arp_spoofing()
