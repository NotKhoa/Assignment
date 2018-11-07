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
			associate_system_menu "$name"
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
			led_menu "$name"
			;;
	esac
}

associate_system_menu() {
	local led_name=$1
	local file="trigger"
	local array=()
	fileline=$(cat $file)
	local count=0

	echo "Associate $name with a system event"
	echo "=========================================="
	echo "Available events are: "
	echo "---------------------"
	
	for line in $fileline; do	# reading trigger file, automatically separate the whitespaces
		array[$count]=${line}	# creating an array to store names
		((count++))
		echo $count. "$line"
	done

	((count++))
	echo $count. Quit to previous menu

	associate_system_menu_input "$led_name" "${array[@]}"	# passing array to input menu

}

associate_system_menu_input() {
	local array=("$@")
	local total=${#array[@]}

	printf "Please select an option (1-%d): " "$total"
	read -r input	# Read user input
	
	if [ "$input" -eq "$input" ] 2>/dev/null; then	# check if user input is an integer
		if [ "$input" -eq "$total" ]; then	# if user wants to quit
			led_menu "$led_name"
		elif [[ "$input" -gt 0 && "$input" -lt "$total" ]]; then
			trigger_name=${array[$input]}	# stores name of trigger
			echo "$trigger_name">trigger	# calls trigger name into trigger file
			led_menu "$led_name"
		else
			echo "Invalid Input... Try Again"
			clear
			associate_system_menu "$led_name"
		fi
	else
		echo "Invalid Input... Try Again"
		associate_system_menu "$led_name"
	fi

}


start_menu
