#!/usr/bin/env sh

export LC_ALL=C

SHAD="$1"

# OUTPUT="/Volumes/RAM/_Output"
OUTPUT="_Output"

source "vehicles.sh"

for i in "${vehicles[@]}"
do
	data=(${i//,/ })
	vehicle=${data[0]}
	dpass=${data[4]}

	if [ "$SHAD" -eq "0" ]
	then
		if [ "_${vehicle}.scad" -nt "$OUTPUT/_Frames/${vehicle}" ]
		then
			./render.sh ${vehicle} "$SHAD"
		fi
	else
		if [ "_${vehicle}.scad" -nt "$OUTPUT/_Shadows/${vehicle}" ]
		then
			./render.sh ${vehicle} "$SHAD"
		fi
	fi
done
wait
