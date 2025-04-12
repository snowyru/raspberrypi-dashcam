#!/bin/bash

# Remove files older than 60 days
find /media/raspberrypi/Dashcam -type f -iname '*.flv' -mtime +60 -exec rm {} \;

# Start dashcam service
/home/raspberrypi/Desktop/dashcam.sh
