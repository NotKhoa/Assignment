#!/bin/bash

start_menu() {
	local array=()
	local counter=0
	printf "Welcome to Led_Konfigurator\n"
	printf "===========================\n"
	
	for i in /sys/class/leds/* ; do
		if [ -d "$i" ]; then
			array[$counter]=${i} 
			((counter++))
			echo $counter. "$(basename "$i")"
		fi
	done
	((counter++))
	echo $counter. "Quit"
	start_menu_input "${array[@]}" 
}

start_menu_input() {
	local array=("$@")
	local total=$((${#array[@]} + 1))
	printf "Please enter a number (1-%d) for the led to configure or quit: " "$total"
	read -r input
	if [ "$input" -eq "$input" ] 2>/dev/null; then	# Check user input is an integer
		if [ "$input" -eq "$total" ]; then	# if user wants to quit
			exit 0
		elif [[ "$input" -lt "$total" && "$input" -gt 0 ]]; then	# User input is correct
			directory=${array[$input-1]}	# Stores directory into variable
			cd "$directory" || 2>/dev/null	# Move to input directory or move to null error
			led_menu "$(basename "$directory")"
		else
			echo "Invalid input.. Returning to menu"
			start_menu
		fi
	else
		echo "Invalid input.. Returning to menu"
		start_menu
	fi
}

led_menu() {
	local name=$1
	echo "$name"
	echo "=============="
	echo "What would you like to do with this led?"
	echo "1. Turn on"
	echo "2. Turn off"
	echo "3. Associate with a system event"
	echo "4. Associate with the performance of a process"
	echo "5. Stop association with a process' performance"
	echo "6. Quit to main menu"
	led_menu_input "$name"
	
}

led_menu_input() {
	name=$1
	printf "Please enter a number (1-6) for your choice: "
	read -r input
	case $input in
		1)
			echo "Turning on..."
			echo "1">brightness
			;;
		2)
			echo "Turning off..."
			echo "0">brightness
			;;
		3)
			echo "Associate with a system event"
			;;
		4)
			echo "Associate with performance of process"
			;;
		5)
			echo "Stopping association"
			;;
		6)
			start_menu
			;;
		*)
			echo "Invalid Input..."
			led_menu $name
			;;
	esac
}

start_menu
