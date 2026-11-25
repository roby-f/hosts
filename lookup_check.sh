#!/bin/bash

cat /etc/hosts | {
	while read line; do
		ip_address=`echo "$line" | cut -f1 -d' '`
		name=`echo "$line" | cut -f1 -d' ' --complement`

		check_ipv6=`echo "$ip_address" | cut -f1 -d':'`
		check_ipv4=`echo "$ip_address" | cut -f1 -d'.'`

		if [ "$ip_address" != "$check_ipv4" -a "$ip_address" = "$check_ipv6" ]; then
			found_ip="0"

			nslookup "$name" 8.8.8.8 | {
				found_name="0"
				while read line_2; do
					if [ "${line_2:0:5}" = "Name:" -a "$(echo $line_2 | cut -f2 -d' ')" = "$name" ]; then
						found_name="1"
					elif [ "$found_name" = "1" -a "${line_2:0:8}" = "Address:" ]; then
						found_name="0"

						check_address=`echo "$line_2" | cut -f2 -d' '`
						if [ "$check_address" = "$ip_address" ]; then
							echo "$check_address - Correct IP address for $name in /etc/hosts"
			                        else
			                                echo "$check_address - Bogus IP address for $name in /etc/hosts!"
			                        fi

					fi
				done
			}
		fi
	done
}
