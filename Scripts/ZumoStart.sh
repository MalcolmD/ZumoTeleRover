#!/bin/bash
CURDIR=$(dirname $0)
cd $CURDIR

# Start ngrok
cd ../ngrok/
./ngrok start -all -log=stdout > ngrok.log &
NGK_PID=$!
sleep 4

cd ../RPi-Arduino\ Communication/Raspberry\ Pi\ Side/TeleControl/
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
	./ngrok_urls.sh
	sleep 20
done


