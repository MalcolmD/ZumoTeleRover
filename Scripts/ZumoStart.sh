#!/bin/bash
WDIR=/home/pi/scripts

# Kick off the camera feed...
#cd /home/pi/ZumoBot/mjpg-streamer/mjpg-streamer
#./mjpg_streamer -i "./input_uvc.so" -o "./output_http.so -w ./www" &
#CAM_PID=$!
#sleep 3

# Kick off control tcp server...
#cd /home/pi/ZumoBot/ZumoBot/RPi-Arduino\ Communication/Raspberry\ Pi\ Side
#python -O Zumo_Robo_srv.py &
#CTL_PID=$!
#sleep 3

# Start ngrok
cd /home/pi/ZumoBot
./ngrok start -all -log=stdout > ngrok.log &
NGK_PID=$!
sleep 4

cd /home/pi/ZumoBot/ZumoBot/Application/Alpha\ Bot\ Solution/ZumoBot/Web-Control/
python -O main.py &
CTL_PID=$!
sleep 2


echo
/home/pi/ZumoBot/ZumoBot/Scripts/ngrok_urls.sh
echo

function cleanup()
{
  echo "Closing things down..."
  echo "Closing ngrok"
  kill $NGK_PID
  sleep 3
  echo "Closing Zumo Control"
  kill $CTL_PID
  sleep 3
  exit
}

trap cleanup INT

while true
do
	echo "Running Zumo..."
	sleep 20
done


