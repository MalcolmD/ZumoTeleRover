#!/bin/bash
CURDIR=$PWD

# Update all our packages and software
sudo apt-get update && sudo apt-get upgrade

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

# Intialize ngrok
cd ngrok/
./ngrok

# Add enviroment variables for zumo to run...
echo "alias ZumoStart=~/ZumoTeleRover/Scripts/ZumoStart.sh" >> ~/.bashrc
echo "export ZumoDir=/home/pi/ZumoTeleRover/" >> ~/.bashrc
