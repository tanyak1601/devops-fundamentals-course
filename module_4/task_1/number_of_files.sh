#!/usr/bin/env bash

red='\033[0;31m'
green='\033[0;32m'
color_off='\033[0m'

dir=$1

if [[ $# -ne 1 ]]; then
    echo -e "${red}Please provide a directory as the first argument${color_off}"
    exit 1
fi

echo -e "Counting the number of files in a ${green}${dir}${color_off} directory and subdirectories..."

count=$(find "$dir" -type f | wc -l)

echo -e "\nNumber of files is ${green}${count}${color_off}\n"