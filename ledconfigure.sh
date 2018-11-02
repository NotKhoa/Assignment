#!/bin/bash

start_menu() {

	counter=0
	printf "Welcome to Led_Konfigurator\n"
	printf "===========================\n"
	
	for i in /sys/class/led/* ; do
		if [ -d "$i" ]; then
			((counter++))
			echo $counter. $(basename "$i")
		fi
	done
	((counter++))
	echo $counter. "Quit"
	total=$counter
	start_input
}

start_input {
	
	counter=0
	printf "Please enter a number (1-$total) for the led to configure or quit: "
	read input
	if [ $input -eq $total ]; then
		echo "exit"
		exit 0
	fi

	for i in /sys/class/leds/* ; do
		if [ -d "$i" ]; then
			((counter++))
			if [ $counter -eq $input ]; then
				directory=$(basename "$i")
				echo $directory
				break
			fi
		fi
	done
	cd /sys/class/leds/$directory

}
