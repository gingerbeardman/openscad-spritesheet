#!/usr/bin/env sh

export LC_ALL=C

ROTS=90
CAR="$1"
SHAD="$2"
MAX="11"
TOTAL=$(( $MAX*$ROTS ))

OUTPUT="_Output"
#for file in *.scad; do echo $file; done

mkdir -p "$OUTPUT/_Frames/$CAR/" 2> /dev/null

# DEBUG="2> /dev/null"
DEBUG=""

# RGB
DARK="[1,0,0]"
DITHER="[0,1,0]"
LIGHT="[0,0,1]"
if [ ${CAR} == "w2-hub" ];
then
    # DARK
    DARK="[1,1,1]"
    DITHER="[1,1,1]"
    LIGHT="[0,0,0]"
fi
if [ ${CAR} == "w2-tyre" ];
then
    # LIGHT
    DARK="[0,0,0]"
    DITHER="[1,1,1]"
    LIGHT="[1,1,1]"
fi

# uv=`echo "${CAR}" | tr a-z A-Z`
uv=${CAR}
printf "$CAR: rendering "; [[ "$SHAD" == "0" ]] && echo "SPRITE"; [[ "$SHAD" == "1" ]] && echo "SHADOW"

# for p in {1..$MAX};
p=1
while [ $p -le $MAX ]
do
    case $p in
        1)
        RF="1"
        RB="0"
        RR="0"
        RL="1"
        JU="0"
        ;;
        2)
        RF="1"
        RB="0"
        RR="0"
        RL="0"
        JU="0"
        ;;
        3)
        RF="1"
        RB="0"
        RR="1"
        RL="0"
        JU="0"
        ;;
        4)
        RF="0"
        RB="0"
        RR="0"
        RL="1"
        JU="0"
        ;;
        5)
        RF="0"
        RB="0"
        RR="0"
        RL="0"
        JU="0"
        ;;
        6)
        RF="0"
        RB="0"
        RR="1"
        RL="0"
        JU="0"
        ;;
        7)
        RF="0"
        RB="1"
        RR="0"
        RL="1"
        JU="0"
        ;;
        8)
        RF="0"
        RB="1"
        RR="0"
        RL="0"
        JU="0"
        ;;
        9)
        RF="0"
        RB="1"
        RR="1"
        RL="0"
        JU="0"
        ;;
        10)
        RF="0"
        RB="1"
        RR="0"
        RL="0"
        JU="1"
        ;;
        11)
        RF="1"
        RB="0"
        RR="0"
        RL="0"
        JU="-1"
        ;;
    esac

    if [ "$RR" == "$RL" ]; then
        TURN="N"
    fi
    if [ "$RR" == "1" ]; then
        TURN="R"
    fi
    if [ "$RL" == "1" ]; then
        TURN="L"
    fi

    if [ "$RF" == "$RB" ]; then
        WEIGHT="N"
    fi
    if [ "$RF" == "1" ]; then
        WEIGHT="F"
    fi
    if [ "$RB" == "1" ]; then
        WEIGHT="R"
    fi

    if [ "$JU" == "1" ]; then
        JUMP="U"
    fi
    if [ "$JU" == "-1" ]; then
        JUMP="D"
    fi
    if [ "$JU" == "0" ]; then
        JUMP="N"
    fi

    if [ "$SHAD" == "0" ];
    then
        FOLDER="$OUTPUT/_Frames/$CAR"
        mkdir -p "${FOLDER}"
        touch -am -r "_${CAR}.scad" "${FOLDER}"
        MODE="SPRITE"
    else
        FOLDER="$OUTPUT/_Shadows/$CAR"
        mkdir -p "${FOLDER}"
        touch -am -r "_${CAR}.scad" "${FOLDER}"
        MODE="SHADOW"
    fi

    FRAME="${WEIGHT}-${TURN}-${JUMP}"
 
    PC=$(( (100000/${TOTAL}*1000)/1000 ))
    PROGRESS=$(( ((p)*$ROTS) ))
    PCDONE=$(( ((${PC}*${PROGRESS})/1000) +1 ))

    # printf "\rrendering $CAR: ($PCDONE%%)"
    # printf "rendering: $FRAME\n"
    openscad \
    -q \
    -D rl=$RL \
    -D rr=$RR \
    -D rf=$RF \
    -D rb=$RB \
    -D jump=$JU \
    -D shad=$SHAD \
    -D dark="$DARK" \
    -D dither="$DITHER" \
    -D light="$LIGHT" \
    --autocenter \
    --imgsize 320,320 \
    --projection p \
    --animate $ROTS \
    --export-format png \
    -o $FOLDER/$(printf %02d $p)-$CAR-$FRAME-.png \
    _$CAR.scad &

    i=$(( $i + $ROTS ))

    p=$(( $p + 1 ))
done
wait
# echo "done $CAR $SHAD"
