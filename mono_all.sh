#!/usr/bin/env sh
source "vehicles.sh"

export LC_ALL=C

FORCE="$1"

ROTS=90
WIDTH=$(( $ROTS*38 ))
HEIGHT=$(( 11*38 ))
IMGSIZE="${WIDTH}x${HEIGHT}"
IMGTABLE="-table-38-38.png"

# OUTPUT="/Volumes/RAM/_Output"
OUTPUT="_Output"

# create 10MB RAM disk /Volumes/RAM
# diskutil quiet partitionDisk $(hdiutil attach -nomount ram://20480) 1 GPTFormat HFS+ 'RAM' '100%'

for i in "${vehicles[@]}"
do
	data=(${i//,/ })
	vehicle=${data[0]}
	limit=${data[1]}
	wheels=${data[2]}
	
	# uv=$( echo "${vehicle}" | tr a-z A-Z )
	uv=${vehicle}
	
	SPRITE="$OUTPUT/_SheetsFrames/${vehicle}*.png"
	MONO="$OUTPUT/_Mono/${vehicle}${IMGTABLE}"
	SHEETSHADOW="$OUTPUT/_SheetsShadows/${vehicle}*.png"
	MONOCOLLIDE="$OUTPUT/_Mono/_collide-${vehicle}${IMGTABLE}"

	if [ "_${vehicle}.scad" -nt $MONO ] || [ $FORCE -eq "1" ]
	then
	
		echo "${uv}: converting SPRITE to MONO using RGBA channels, appending SHADOW"
		
		GFILE="$OUTPUT/dailydriver-render.green.png"
		DFILE="$OUTPUT/dailydriver-render.detail.png"
		RFILE="$OUTPUT/dailydriver-render.result.png"

		## TEMP DETAIL IMAGE
		magick $SPRITE -channel G -separate -threshold 15% $GFILE
		
		## PATTERN DETAILS
		magick \( \( -size $IMGSIZE pattern:gray50 -alpha on \) \( $GFILE -transparent black -background white \) -compose Dst_In -composite \) $DFILE
		
		## COMPOSITE CHANNELS
		magick \
		-page 0 \( $SPRITE -channel R -separate -threshold 15% -negate \) \
		-page 0 \( $DFILE \) \
		-page 0 \( $SPRITE -channel B -separate -threshold 15% -transparent black \) \
		-flatten \
		\( $SPRITE -channel A -separate \) -alpha off \
		-compose copy_opacity \
		-composite \
		$RFILE
		
		## COMPOSITE WHEELS
		# if [ "$wheels" -eq "1" ]
		# then
		# 	magick $RFILE 2ww9long.png -geometry +1-1 -composite $MONO
		# else
			cp $RFILE $MONO
		# fi
		
		# copy plain collider with transparent background
		magick $MONO \( $SHEETSHADOW -fuzz 10% -transparent white \) -append +repage $MONO
		
		touch -am -r "_${vehicle}.scad" $MONO
	fi
done

## ERROR CLEAN UP
function ExitWithError
{
  echo "$*">&2
  rm -f $GFILE $DFILE $RFILE
  exit 1
}
function Tidyup
{
  ExitWithError "Abort"
}
trap Tidyup 1 2 3 15

## NORMAL CLEANUP
rm -f $GFILE $DFILE $RFILE

# eject RAM disk
# diskutil quiet eject /Volumes/RAM

exit 0
