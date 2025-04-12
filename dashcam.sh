#!/bin/bash

# Set variable for the date
when=$(date)

# Make sure dashcam.log is present
touch dashcam.log

# Check if the previous video exists and move it with a timestamp
if [ -f /media/raspberrypi/Dashcam/dashcam.flv ]; then
  mv /media/raspberrypi/Dashcam/dashcam.flv /media/raspberrypi/Dashcam/$(date +%F-%H:%M).dashcam.flv
fi

# Log the service start time
echo "Started at: $when" >> dashcam.log

# Record video using FFmpeg
ffmpeg -f v4l2 -input_format mjpeg -video_size 1024x760 -i /dev/video0 \
-vcodec libx264 -preset ultrafast -an -f flv -r 25 /media/raspberrypi/Dashcam/dashcam.flv -y
