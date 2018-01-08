#!/bin/bash

echo $1
declare -i X_START
declare -i Y_END
declare -i POS_X
declare -i POS_Y

if [ "$1" != "" ]; then
    rm -f /vagrant/certificate-$1.png
    WIDTH_IN_PIXELS=1620 # the width of the "name goes here" space of the certificate
    X_START=1180
    Y_END=1130
    CHARS=${#1}
    FONT_SIZE=$(((WIDTH_IN_PIXELS - 20) / CHARS * 2))
    POS_X=$X_START
    POS_Y=$((Y_END - ( WIDTH_IN_PIXELS / CHARS ) + 50 ))
    echo "chars: $CHARS width: $WIDTH_IN_PIXELS x: $POS_X y: $POS_Y"
    # sudo convert -pointsize $FONT_SIZE -fill black -draw "text $POS_X,$POS_Y \"${1}\" " /home/jenkins/certificate.png /vagrant/out.png -verbose
    sudo convert -pointsize $FONT_SIZE -fill black -draw "text $POS_X,$POS_Y \"$1\" " /home/jenkins/certificate.png /vagrant/certificate-$1.png
else
    echo "Positional parameter 1 is empty"
fi

#  certificate-${1}.png