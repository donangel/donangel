#!/bin/zsh
HOSTS=("8.8.8.8")
COUNT=3
SIZE=64

# Function to check for a key press in the background
check_keypress() {
    while true; do
        read -k 1 -t 0.1
        if [[ $? -eq 0 ]]; then
            echo "Key pressed, exiting."
            kill -SIGTERM $$  # Sends termination signal to the current script
            return
        fi
    done
}

# Start the check_keypress function in the background
check_keypress &

while true
do
    for myHost in "${HOSTS[@]}"
    do
        currentTime=$(date +"%H:%M:%S")
        lossPercentage=$(ping -q -n -s $SIZE -c $COUNT $myHost | grep "packet loss" | awk '{print $7}')
        echo "[$currentTime] $lossPercentage @ $myHost ($COUNT x $SIZE)"
    done
done
