#!/bin/bash
# This script will control the processor temperature
# Requirements:
#   required packages: lm_sensors

VERSION="0.0.1\nScript to send with telegram CPU temperature"

TELEGRAM_TOKEN_FILE=./config/telegram-token.dist

if [ ! -f $TELEGRAM_TOKEN_FILE ]; then
	echo $TELEGRAM_TOKEN_FILE " file, does not exist"
	exit 1
fi

# Read telegram token from file
TELEGRAM_TOKEN=$(<$TELEGRAM_TOKEN_FILE)
# Read cpu temperature using sensors
CPU_TEMPERATURE=$(sensors | grep "Core 0" | awk '{print $3}' | cut -c 2-)
CPU_TEMPERATURE_INT=$(echo $CPU_TEMPERATURE | tr -d .°C)
if [ $CPU_TEMPERATURE_INT -gt 700 ]; then
	# Send telegram message
	echo "Raspberry temperature is to high"
fi

exit 0
