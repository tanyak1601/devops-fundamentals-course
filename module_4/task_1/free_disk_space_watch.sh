#!/usr/bin/env bash
red='\033[0;31m'
green='\033[0;32m'
color_off='\033[0m'

default_threshold=1000000
threshold=${1:-$default_threshold}

echo -e "Start monitoring free disk space. Threshold is ${green}${threshold}${color_off}"

while true
do  
    free_space=$(df | tail -n +2 | awk '{s+=$4} END {print s}')
    echo "Free space: $free_space"
    if [ "$free_space" -le "$threshold" ]
    then
        echo -e "${red}Warning: Free disk space is ${free_space}. It is less then threshold $threshold${color_off}"
    fi
    sleep 20
    echo "Continue monitoring..."
done