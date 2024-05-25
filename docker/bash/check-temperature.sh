#!/bin/sh
# This script will control the processor temperature
# Requirements:
#   required packages: lm_sensors

VERSION="0.0.1\nScript to send with telegram CPU temperature"

# Read cpu temperature using sensors
CPU_TEMPERATURE=$(sensors | grep "Core 0" | awk '{print $3}' | cut -c 2- | tr -d °)
CPU_TEMPERATURE_INT=$(echo $CPU_TEMPERATURE | tr -d .°C)
if [ $CPU_TEMPERATURE_INT -gt 100 ]; then
	MESSAGE="Raspberry CPU temperature is too high: ${CPU_TEMPERATURE}"
	# Send telegram message though sendMessage
	/var/tmp/scripts/commands/sendMessage.sh "$MESSAGE"
fi

exit 0
