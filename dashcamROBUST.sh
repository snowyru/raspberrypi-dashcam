#!/bin/bash

# Set default resolution and frame rate
RESOLUTION="640x480"
FRAMERATE=30

# Set the output directory
OUTPUT_DIR="/media/raspberrypi/Dashcam"

# Ensure the output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Output directory $OUTPUT_DIR does not exist. Creating it..."
    mkdir -p "$OUTPUT_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create output directory. Exiting."
        exit 1
    fi
fi

# Get the current date and time for file naming
CURRENT_DATETIME=$(date +%Y%m%d_%H%M%S)

# Function to record from a video device with robust options
record_video_robust() {
    local DEVICE=$1
    local OUTPUT_FILE=$2

    if [ -e "$DEVICE" ]; then
        echo "Recording (robust mode) from $DEVICE to $OUTPUT_FILE..."
        ffmpeg -f v4l2 -framerate $FRAMERATE -video_size $RESOLUTION \
        -i "$DEVICE" -c:v libx264 -preset ultrafast -tune zerolatency \
        -flush_packets 1 -f matroska "$OUTPUT_FILE" &
    else
        echo "Device $DEVICE not found. Skipping."
    fi
}

# Trap SIGINT (Ctrl+C) and SIGTERM to clean up background processes
cleanup() {
    echo "Stopping all recordings..."
    kill $(jobs -p) 2>/dev/null
    wait
    echo "All recordings stopped. Exiting."
    exit 0
}

trap cleanup SIGINT SIGTERM

# Record from /dev/video0 to [currentdateandtime]dash.mkv
record_video_robust "/dev/video0" "$OUTPUT_DIR/${CURRENT_DATETIME}dash.mkv"

# Record from /dev/video2 to [currentdateandtime]gap.mkv
record_video_robust "/dev/video2" "$OUTPUT_DIR/${CURRENT_DATETIME}gap.mkv"

# Wait for all background processes (recording) to finish
wait