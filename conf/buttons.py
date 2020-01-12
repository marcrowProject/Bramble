# Imports
import time
import RPi.GPIO as GPIO
import uinput
import subprocess

#1.Install the python lib
#$sudo apt-get update
#$sudo apt-get install libudev-dev
#$sudo apt-get install python-pip
#$sudo pip install rpi.gpio
#$sudo pip install python-uinput

#2. Perform the command
#$sudo modprobe uinput
subprocess.call(["/sbin/modprobe", "uinput"])
# pins definition
pinBtn = 26
pinBtn1 = 19
pinBtn2 = 13


events = (uinput.KEY_LEFTCTRL, uinput.KEY_Y,uinput.KEY_N, uinput.KEY_C, uinput.KEY_ENTER)

device = uinput.Device(events)
GPIO.setmode(GPIO.BCM)

# Confire default pin state in/out up/down
GPIO.setup(pinBtn, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(pinBtn1, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(pinBtn2, GPIO.IN, pull_up_down = GPIO.PUD_UP)



#infinity loop
while True:
    state = GPIO.input(pinBtn)  
    if (state == 0) : #The button (pinBtn) is pressed
        device.emit(uinput.KEY_Y, 1) #simulates the pressing of the y key in the current window 
    	device.emit(uinput.KEY_Y, 0)
    	device.emit(uinput.KEY_ENTER, 1) #simulates the pressing of the enter key in the current window
    	device.emit(uinput.KEY_ENTER, 0)


    state = GPIO.input(pinBtn1)
    if (state == 0) : #same thing but with 'n'
        device.emit(uinput.KEY_N, 1) 
    	device.emit(uinput.KEY_N, 0)
    	device.emit(uinput.KEY_ENTER, 1) 
    	device.emit(uinput.KEY_ENTER, 0)
    
    state = GPIO.input(pinBtn2)
    if (state == 0) :
    	device.emit(uinput.KEY_LEFTCTRL, 1) 
    	device.emit(uinput.KEY_C, 1)
        device.emit(uinput.KEY_LEFTCTRL, 0) 
        device.emit(uinput.KEY_C, 0)
    # avoids using too many resources
    time.sleep(0.3)
