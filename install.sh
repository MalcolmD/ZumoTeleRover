#!/bin/bash
CURDIR=$PWD

if [ $# -ne 1 ]; then

	echo "Please try again with the authentication code provided as an argument to install the Zumo Software"

else
	# Update all our packages and software
	sudo apt-get update && sudo apt-get upgrade -y

	# First we need to enable the camera
	sudo raspi-config nonint do_camera 0

	# Requires cmake
	sudo apt-get install cmake

	# Requires jpeglib
	sudo apt-get install libjpeg9-dev


	# Install mjpeg-streamer
	cd mjpg-streamer/mjpg-streamer-experimental/
	make

	# Install Python dependencies
	cd $CURDIR
	sudo apt-get install python-pip -y
	python -m pip install bottle
	python -m pip install pyserial

	# Initialize ngrok
	cd ngrok/
	./ngrok $1
	
	echo "" >> ~/.ngrok2/ngrok.yml
	cat ngrok.yml >> ~/.ngrok2/ngrok.yml
	
	# Ask for user/password for control access
	echo ""
	echo -n "Please provide a username to access Zumo Control: "
  read USER

  echo -n "Please provide a password to access Zumo Control: "
  read PASS

  printf "\nYour user:pass credentials to access the controls page are...\nuser: ${USER}\npassword: ${PASS}\n"
	
	printf "    auth: \"${USER}:${PASS}\"\n" >> ~/.ngrok2/ngrok.yml

	# Add environment variables for zumo to run...
	echo "alias ZumoStart=~/ZumoTeleRover/Scripts/ZumoStart.sh" >> ~/.bashrc
	echo "export ZumoDir=/home/pi/ZumoTeleRover/" >> ~/.bashrc
fi