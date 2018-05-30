#!/bin/bash

echo "Press y to pass in right-hander mode"
echo "Press n to pass in left-hander mode"
read ans
if [ $ans == "y" ]; then
	sed -i 's/k1=24/k1=18/g' conf/rpi-2.2TFT-kbrd.py
	sed -i 's/k3=18/k3=24/g' conf/rpi-2.2TFT-kbrd.py
else
	sed -i 's/k1=18/k1=24/g' conf/rpi-2.2TFT-kbrd.py
	sed -i 's/k3=24/k3=18/g' conf/rpi-2.2TFT-kbrd.py
fi