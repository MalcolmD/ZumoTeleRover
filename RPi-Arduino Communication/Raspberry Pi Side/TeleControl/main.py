#!/usr/bin/python
# -*- coding:utf-8 -*-
from bottle import get,post,run,route,request,template,static_file
import threading
import json
import socket #ip
import serial
import os

# Get path to root of our project
abspath = os.path.abspath(__file__)
projroot = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(abspath))))


# Serial Commands sent to Zumo

# Initialize serial communication
# --------------------------------------


def right():
		if __debug__:

			print "Move right."

		ser.write(str(3).encode('utf-8'))
    
def left():
		if __debug__:

			print "Move left."

		ser.write(str(2).encode('utf-8'))
    
def forward():
		if __debug__:

			print "Move forward."

		ser.write(str(1).encode('utf-8'))
    
def backward():
		if __debug__:

			print "Move backward."

		ser.write(str(4).encode('utf-8'))

def arm():
		if __debug__:
			print "Move arm."
		
		ser.write(str(5).encode('utf-8'))

@get("/")
def index():
	return template("index")
	
@route('/<filename>')
def server_static(filename):
    return static_file(filename, root='./')

@route('/fonts/<filename>')
def server_fonts(filename):
    return static_file(filename, root='./fonts/')

@get('/feed')
def feed():
	if __debug__:
		s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
		s.connect(("8.8.8.8", 80))
		ip_addr = s.getsockname()[0]
		s.close()
		return  "http://" + ip_addr + ":8080"
	else:

		os.system("curl http://localhost:4040/api/tunnels > tunnels.json")

		with open('tunnels.json') as data_file:
			datajson = json.load(data_file)
		tunnels = datajson['tunnels']
		camera_tunnel = [x for x in tunnels if x['name'] == "camera"][0]
		url = camera_tunnel['public_url']

		return template('{{message}}', message=url)

@post("/cmd")
def cmd():
    code = request.body.read().decode()
    speed = request.POST.get('speed')
    print(code)
    if(speed != None):
        print(speed)
    if code == "stop":
        #RPiSer.stop()
        print("stop")
    elif code == "forward":
        forward()
    elif code == "backward":
        backward()
    elif code == "turnleft":
        left()
    elif code == "turnright":
        right()
    elif code == "movearm":
	arm()
    return "OK"

# Set up the camera feed
def camera():
    campath = projroot + "/mjpg-streamer/mjpg-streamer-experimental/"
    print("campath = %s" %campath)
    os.system(campath  + './mjpg_streamer -i "' + campath + './input_uvc.so" -o "' + campath + './output_http.so -w ' + campath + './www"')

# Set up serial connection to Arduino connected via USB at location 'dev'ttyACM0'
try:
	ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
	ser.flush()
except serial.SerialException:
	print("Error with connection to arduino, please make sure there is a USB cable plugged in from the raspberry pi to the arduino.")  


tcamera = threading.Thread(target = camera)
tcamera.setDaemon(True)
tcamera.start()

# run the server, if we're debugging, we're using our local network, otherwise
# non-debugging means we're using ngrok, and in that case we need to serve to localhost,
# so ngrok can reverse tunnel and serve it to the web.
localhost = 'localhost'

if  __debug__:
	s = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
	s.connect(('8.8.8.8',80))
	localhost=s.getsockname()[0]

run(host = localhost, port = 8000)

