#!/bin/bash

# This script is for increasing the volume of all PulseAudio sinks.
# Usage: <change-percentage>

if [[ $# -ne 1 ]]; then
	echo "Usage: <change-percentage>"
	exit 1
fi

SINKS=$(pactl list sinks | grep Sink | cut -c7-)

for sink in $SINKS; do
	pactl set-sink-volume $sink $1
done
