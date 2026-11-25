#!/bin/bash

name="$1"
ip_address="$2"
dns="$3"

found_ip="0"

nslookup "$name" "$dns" | {
        found_name="0"
	found_ip="0"

        while read line_2; do
                if [ "${line_2:0:5}" = "Name:" -a "$(echo $line_2 | cut -f2 -d' ')" = "$name" ]; then
                        found_name="1"
                elif [ "$found_name" = "1" -a "${line_2:0:8}" = "Address:" ]; then
                        found_name="0"

                        check_address=`echo "$line_2" | cut -f2 -d' '`
                        if [ "$check_address" = "$ip_address" ]; then
				found_ip="1"
                        fi

                fi
        done

	if [ "$found_ip" = "1" ]; then
	        echo "$ip_address - Valid address for $name"
	else
	        echo "$ip_address - Invalid address for $name!"
	fi
}
