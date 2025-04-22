#!/bin/bash

# Set GPIO pin 5 (GPIO3) to input
gpio -g mode 3 in
gpio -g mode 3 up  # Enable internal pull-up resistor

# Monitor GPIO pin 5 for a button press
while true; do
    if [ "$(gpio -g read 3)" -eq "0" ]; then
        echo "Shutdown initiated by power button" >> ~/Desktop/shutdown_log.txt
        pkill -f dashcam.sh
        sleep 3
        sudo shutdown -h now
        break
    fi
    sleep 0.1
done
