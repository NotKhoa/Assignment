#!/bin/bash

start_menu() {
	local array=()
	local counter=0
	printf "Welcome to Led_Konfigurator\n"
	printf "===========================\n"
	
	for i in /sys/class/led/* ; do
		if [ -d "$i" ]; then
			array[$counter]=${i} 
			((counter++))
			echo $counter. "$(basename "$i")"
		fi
	done
	((counter++))
	echo $counter. "Quit"
	start_input_menu "${array[@]}" 
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


