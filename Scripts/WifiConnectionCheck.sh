if iwconfig 2>&1 | grep ESSID | grep "off/any" > /dev/null; then 
	echo no connection.;
	sudo sh -c "echo none > /sys/class/leds/led0/trigger";
else
	echo connection found!;
	sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger";
fi
