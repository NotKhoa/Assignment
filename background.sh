#!/bin/bash
program_name=$2

main() {
	while getopts ":m:c:" opt; do
		case $opt in
			m)
				while true; do 
					process_monitor %mem
				done
				;;
			c)
				while true; do
					process_monitor %cpu
				done
				;;
			*)
				echo "Invalid option: -$OPTARG"
				;;
		esac
	done
	
}

process_monitor() {
	option=$1
	array=($(ps -eo "$option",args | grep "$program_name" | awk '{print $1}'))
	total=$( IFS="+"; bc <<< "${array[*]}" )	# Add together the process usage

	if [ "$(echo "$total<10" | bc)" ]; then
		led_function 0.01 10
	elif [[ $(echo "$total<20" | bc) && $(echo "$total>=10" | bc) ]]; then
		led_function 0.1 0.9
	elif [[ $(echo "$total<30" | bc) && $(echo "$total>=20" | bc) ]]; then
		led_function 0.2 0.8
	elif [[ $(echo "$total<40" | bc) && $(echo "$total>=30" | bc) ]]; then
		led_function 0.3 0.7
	elif [[ $(echo "$total<50" | bc) && $(echo "$total>=40" | bc) ]]; then
		led_function 0.4 0.6
	elif [[ $(echo "$total<60" | bc) && $(echo "$total>=50" | bc) ]]; then
		led_function 0.5 0.5
	elif [[ $(echo "$total<70" | bc) && $(echo "$total>=60" | bc) ]]; then
		led_function 0.6 0.4
	elif [[ $(echo "$total<80" | bc) && $(echo "$total>=70" | bc) ]]; then
		led_function 0.7 0.3
	elif [[ $(echo "$total<90" | bc) && $(echo "$total>=80" | bc) ]]; then
		led_function 0.8 0.2
	elif [[ $(echo "$total<100" | bc) && $(echo "$total>=90" | bc) ]]; then
		led_function 0.9 0.1
	elif [ "$total" -eq 100 ]; then
		led_function 1 0
	fi

}

led_function() {
	local on=$1
	local off=$2
	echo "1">brightness
	sleep "$on"
	echo "0">brightness
	sleep "$off"
}

main "$@"
