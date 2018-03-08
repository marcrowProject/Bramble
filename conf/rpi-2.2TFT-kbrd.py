""" rpi-2.2TFT-kbrd.py by ukonline2000 2015.12.08
GPIO Keyboard driver for Raspberry Pi 2.2TFT for use with 5 Buttons
requires uinput kernel module (sudo modprobe uinput)
requires python-uinput (git clone https://github.com/tuomasjjrasanen/python-uinput)
requires python RPi.GPIO (from http://pypi.python.org/pypi/RPi.GPIO/)

Steps:

1.Install the python lib
$sudo apt-get update
$sudo apt-get install libudev-dev
$sudo apt-get install python-pip
$sudo pip install rpi.gpio
$sudo pip install python-uinput

2. Perform the command
$sudo modprobe uinput

3. Perform the demo python program
$sudo python rpi-2.2TFT-kbrd.py

"""



import uinput
import time
import os
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

def extinction(channel):
	print("bramble will be turn off")
	GPIO.cleanup()
	os.system('sudo shutdown 0')

# Up, Down, left, right, fire
GPIO.setup(24, GPIO.IN, pull_up_down=GPIO.PUD_UP)  #Trigon Button for GPIO24
GPIO.setup(5, GPIO.IN, pull_up_down=GPIO.PUD_UP)  #X Button for GPIO5
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP)  #Circle Button for GPIO23
GPIO.setup(22, GPIO.IN, pull_up_down=GPIO.PUD_UP)  #Square Button for GPIO22
GPIO.setup(4, GPIO.IN, pull_up_down=GPIO.PUD_UP)  #R Button for GPIO4
#L Button for GPIO17

events = (uinput.KEY_UP, uinput.KEY_DOWN, uinput.KEY_LEFT, uinput.KEY_RIGHT, uinput.KEY_LEFTCTRL, uinput.KEY_Y,uinput.KEY_N, uinput.KEY_O, uinput.KEY_C, uinput.KEY_A, uinput.KEY_ENTER)

device = uinput.Device(events)

GPIO.add_event_detect(5, GPIO.FALLING, callback=extinction) #to turn off the machine

fire = False
up = False
down = False
left = False
right = False

while True:
  if (not fire) and (not GPIO.input(4)):  # Fire button pressed
    fire = True
    device.emit(uinput.KEY_A, 1) # Press Left Ctrl key
    device.emit(uinput.KEY_A, 0)
  if fire and GPIO.input(4):  # Fire button released
    fire = False
    device.emit(uinput.KEY_ENTER, 1)
    device.emit(uinput.KEY_ENTER, 0) # Release Left Ctrl key
  if (not up) and (not GPIO.input(24)):  # Up button pressed
    up = True
    device.emit(uinput.KEY_LEFTCTRL, 1) # Press Up key
    device.emit(uinput.KEY_C, 1)
  if up and GPIO.input(24):  # Up button released
    up = False
    device.emit(uinput.KEY_LEFTCTRL, 0)
    device.emit(uinput.KEY_C, 0) # Release Up key
  """if (not down) and (not GPIO.input(5)):  # Down button pressed
    down = True
    device.emit(uinput.KEY_O, 1) # Press Down key
    device.emit(uinput.KEY_O, 0)
  if down and GPIO.input(5):  # Down button released
    down = False
    device.emit(uinput.KEY_ENTER, 0) # Release Down key """
  if (not left) and (not GPIO.input(23)):  # Left button pressed
    left = True
    device.emit(uinput.KEY_Y, 1) # Press Left key
    device.emit(uinput.KEY_Y, 0)
  if left and GPIO.input(23):  # Left button released
    left = False
    device.emit(uinput.KEY_ENTER, 1) # Release Left key
    device.emit(uinput.KEY_ENTER, 0)
  if (not right) and (not GPIO.input(22)):  # Right button pressed
    right = True
    device.emit(uinput.KEY_N, 1) # Press Right key
    device.emit(uinput.KEY_N, 0)
  if right and GPIO.input(22):  # Right button released
    right = False
    device.emit(uinput.KEY_ENTER, 1)
    device.emit(uinput.KEY_ENTER, 0) # Release Right key
  time.sleep(.04)
