#!/bin/bash
WDIR=".."
CURDIR=$PWD
# Start ngrok
cd $WDIR/ngrok/
./ngrok start -all -log=stdout > ngrok.log &
NGK_PID=$!
sleep 4

cd $WDIR/RPi-Arduino\ Communication/Raspberry\ Pi\ Side/TeleControl/
python -O main.py &
CTL_PID=$!
sleep 2

cd $CURDIR
echo
./ngrok_urls.sh
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


