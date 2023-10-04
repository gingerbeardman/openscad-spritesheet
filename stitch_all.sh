#!/usr/bin/env sh

export LC_ALL=C

ROTS=90
GRID="${ROTS}x11"
IMGTABLE="-table-38-38.png"

# OUTPUT="/Volumes/RAM/_Output"
OUTPUT="_Output"

source "vehicles.sh"

for i in "${vehicles[@]}"
do
	data=(${i//,/ })
	vehicle=${data[0]}
	# limit=${data[1]}
	# wheels=${data[2]}

	# uv=`echo "${vehicle}" | tr a-z A-Z`
	uv=${vehicle}

	SCAD="_${vehicle}.scad"
	SPRITE="$OUTPUT/_Frames/$vehicle"
	SHADOW="$OUTPUT/_Shadows/$vehicle"
	SKIDMARKS="$OUTPUT/_Skidmarks/$vehicle"
	TEMPSPRITE="$OUTPUT/_TempFrames/$vehicle"
	TEMPSHADOW="$OUTPUT/_TempShadows/$vehicle"
	SHEETSFRAMES="$OUTPUT/_SheetsFrames/${vehicle}${IMGTABLE}"
	SHEETSSHADOWS="$OUTPUT/_SheetsShadows/${vehicle}${IMGTABLE}"

	mkdir -p $TEMPSPRITE
	mkdir -p $TEMPSHADOW
	
	if [ "$SCAD" -nt "$SHEETSFRAMES" ]
	then
		echo "${uv}: stitching SPRITE"
		# resize and crop
		convert $(ls -1 $SPRITE/*.png) -filter point -sample 39x39 -crop -1-1 +repage -alpha on -fill none -fuzz 0% -draw 'color 0,0 replace' -roll +0+1 $TEMPSPRITE/%04d.png
		# stitch in sheet
		montage "$TEMPSPRITE/*.png" -geometry 38x38+0+0 -tile $GRID -background none $SHEETSFRAMES
		
		# touch final file
		touch -am -r "_${vehicle}.scad" $SHEETSFRAMES
	fi

	if [ "$SCAD" -nt "$SHEETSSHADOWS" ]
	then
		echo "${uv}: stitching SHADOW"
		# resize and crop
		convert $(ls -1 $SHADOW/*.png) -filter point -sample 39x39 -crop -1-1 +repage -alpha on -fill none -fuzz 0% -draw 'color 0,0 replace' -roll +0+1 $TEMPSHADOW/%04d.png
		# stitch in sheet
		montage "$TEMPSHADOW/*.png" -geometry 38x38+0+0 -tile $GRID -background none $SHEETSSHADOWS

		# touch final file
		touch -am -r "_${vehicle}.scad" $SHEETSSHADOWS
	fi
done
