#!/bin/bash

# Weak sauce URL filter
# The grep isolates the lines from the log that have the tunnel information.
# The "awk" command starts with the '-F' flag which allows me to pass the separator for the line. This means that anytime awk sees the
# pattern "url" it's going to regard that as what separates as my column selections. This means anything before awk sees "url" is regarded as "$1" and 
# anything after "url" is $2.
#grep tunnels name= ../WebServing/ngrok_solution/ngrok.log | awk -Furl= '/url/ {print $2}'

# Really good URL filter
# We grep the log file that I have ngrok spitting out.
# The first awk command substitutes all and every charcter (*) before the pattern "name" and replaces it with nothing. '*' in particular matches zero or more repitions of the previous character or
# expression. Combined with the wildcard, '.', we can match anything and everything.
# The second 'awk' prints the first and third columns from the lines, with a colon and space separated between them. Note that the separators here default to spaces unless awk is told otherwise
# We select these columns in particular, thereby skipping the middle column which just tells us the port on localhost that is being exposed.
# The last column matches with any line that has the pattern "url" in it, this removes the redundant address I get for the camera

grep "tunnels name=" "$ZumoDir"/ngrok/ngrok.log | awk  '{gsub(/.*name=/,"");print}' | awk '{print $1": " $3}' | awk '/url/ {print}'
