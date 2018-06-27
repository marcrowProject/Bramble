cd ..
make
echo
echo "-----update-----"
echo
sudo apt-get update
echo
echo "-----libudev-dev-----"
echo
sudo apt-get -y install  libudev-dev
echo
echo "-----python-pip-----"
echo
sudo apt-get -y install python-pip
echo
echo "-----rpi.gpio-----"
echo
sudo pip install rpi.gpio
echo
echo "-----python uinput-----"
echo
sudo pip install python-uinput
sudo modprobe uinput
echo
echo "-----macchanger------"
echo
sudo apt-get -y install macchanger
echo
echo "-----steghide------"
echo
sudo apt-get -y install steghide
echo
echo "-----nmap------"
echo
sudo apt-get -y install nmap
echo
echo "-----aircrack-ng------"
echo
sudo apt-get -y install aircrack-ng
echo
echo "-----secure-delete------"
echo
sudo apt-get -y install secure-delete
echo
echo "-----foremost------"
echo
sudo apt-get -y install foremost
echo
echo "-----wmctrl------"
echo
sudo apt-get -y install wmctrl
echo
echo "-----ntp ntpdate------"
echo
sudo apt-get -y install ntp ntpdate
echo
echo "-----hydra------"
echo
sudo apt-get -y install hydra
echo
echo "-----tshark------"
echo
sudo apt-get -y install tshark
echo
echo "-----xml-twig-tools------"
echo
sudo apt-get -y install xml-twig-tools
echo
echo "-----python-scapy------"
echo
sudo apt-get -y install python-scapy
echo
echo "-----upgrade pip------"
echo
sudo pip install --upgrade pip
echo
echo "-----netaddr------"
echo
sudo pip install netaddr
echo
echo "----- netifaces------"
echo
sudo pip install netifaces