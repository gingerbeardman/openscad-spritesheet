#!/usr/bin/env sh

export LC_ALL=C

IMGTABLE="-table-38-38.png"

# OUTPUT="/Volumes/RAM/_Output"
OUTPUT="_Output"

source "vehicles.sh"

echo "ALL: touch"

for i in "${vehicles[@]}"
do
	data=(${i//,/ })
	vehicle=${data[0]}

	touch -am -r "_${vehicle}.scad" "$OUTPUT/_Frames/${vehicle}"
	touch -am -r "_${vehicle}.scad" "$OUTPUT/_Frames/${vehicle}/*"

	touch -am -r "_${vehicle}.scad" "$OUTPUT/_Shadows/${vehicle}"
	touch -am -r "_${vehicle}.scad" "$OUTPUT/_Shadows/${vehicle}/*"

	touch -am -r "_${vehicle}.scad" "$OUTPUT/_SheetsFrames/${vehicle}${IMGTABLE}"

	touch -am -r "_${vehicle}.scad" "$OUTPUT/_SheetsShadows/${vehicle}${IMGTABLE}"

	touch -am -r "_${vehicle}.scad" "$OUTPUT/_Mono/${vehicle}${IMGTABLE}"
done
