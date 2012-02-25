#!/bin/bash
# Amit Bakshi (abakshi@gmail.com)
# 2/25/2012

function dot3 {
    echo $(( $1 * $4 + $2 * $5 + $3 * $6 ))
}

function mul3 {
    echo $(( $1 * $4 )) $(( $2 * $5 )) $(( $3 * $6 ))
}

function xform {
    echo $(dot3 $1 $2 $3 $4 $5 $6) \
         $(dot3 $1 $2 $3 $7 $8 $9) \
         $(dot3 $1 $2 $3 ${10} ${11} ${12})
}

function axisrot {
    local x=$1 y=$2 z=$3 a=$4
    local c=`echo $a | awk '{print cos($1) * 100 }' | sed -e 's/\..*//g'`
    local s=`echo $a | awk '{print sin($1) * 100 }' | sed -e 's/\..*//g'`
    local t=$(( 100 - $c ))
    echo $(( $t * $x * $x + $c )) $(( $t * $x * $y - $z * $s )) $(( $t * $x * $z + $y * $s )) \
         $(( $t * $x * $y + $z * $s )) $(( $t * $y * $y + $c )) $(( $t * $y * $z + $x * $s )) \
         $(( $t * $x * $z + $y * $s )) $(( $t * $y * $z + $x * $s )) $(( $t * $z * $z + $c ))
}

width=`tput cols`
height=$LINES
hwidth=`expr $width / 2`
hheight=`expr $height / 2`

function drawxy {
    local x=$1 y=$2 z=$3 c=$4
    tput cup $(( $y + $hheight )) $(( $x + $hwidth ))
    printf "%s" $c
}

declare -a v1=( 7 7 1 )
declare -a v2=( 17 17 1 )
declare -a v3=( 9 9 1 )

rot=0.0
for i in {0..1000}; do
    # increment rotation
    rot=`echo $rot | awk '{print $1 + 0.1}'`
    vec1=( `echo $(xform ${v1[@]} $(axisrot 70 70 0 $rot)) | awk '{printf("%d %d %d",\$1/1000000,\$2/1000000,\$3/1000000)}'` )
    vec2=( `echo $(xform ${v2[@]} $(axisrot 70 70 0 $rot)) | awk '{printf("%d %d %d",\$1/1000000,\$2/1000000,\$3/1000000)}'` )
    vec3=( `echo $(xform ${v3[@]} $(axisrot 70 70 0 $rot)) | awk '{printf("%d %d %d",\$1/1000000,\$2/1000000,\$3/1000000)}'` )
    tput clear
    echo ${vec1[@]}
    echo ${vec2[@]}
    echo ${vec3[@]}
    drawxy ${vec1[@]} "A"
    drawxy ${vec2[@]} "B"
    drawxy ${vec3[@]} "C"
    sleep 0.1
done
