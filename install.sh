 #!/bin/bash
CURDIR=$PWD

# Requires cmake
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install cmake

# Requires jpeglib
sudo apt-get install libjpeg9-dev

# Install mjpeg-streamer
cd mjpg-streamer/mjpg-streamer-experimental/
make

# Install Python dependencies
cd $CURDIR
python -m pip install bottle

# intialize ngrok
cd ngrok/
./ngrok
