#!/bin/bash

declare -i X_START
declare -i Y_END
declare -i POS_X
declare -i POS_Y
try="."

if [ "$1" != "" ]; then
    rm -f /vagrant/certificate-$1.png
    WIDTH_IN_PIXELS=1620 # the width of the "name goes here" space of the certificate
    Y_END=1130
    CHARS=${#1}
    if [ ${#1} -le 20 ]; then
    FONT_SIZE=130
    X_START=1400
    POS_Y=$((Y_END - ( WIDTH_IN_PIXELS / CHARS ) + 85 ))
    elif [ ${#1} -gt 20 ] && [ ${#1} -le 26 ]; then
    FONT_SIZE=120
    X_START=1250
    POS_Y=$((Y_END - ( WIDTH_IN_PIXELS / CHARS ) + 50 ))
    elif [ ${#1} -gt 26 ] && [ ${#1} -le 32 ]; then
    FONT_SIZE=100
    X_START=1150
    POS_Y=$((Y_END - ( WIDTH_IN_PIXELS / CHARS ) + 50 ))
    else
    FONT_SIZE=$(((WIDTH_IN_PIXELS - 20) / CHARS * 2))
    X_START=1150
    POS_Y=$((Y_END - ( WIDTH_IN_PIXELS / CHARS ) + 50 ))
    fi
    POS_X=$X_START
    echo "chars: $CHARS width: $WIDTH_IN_PIXELS x: $POS_X y: $POS_Y"
    # sudo convert -pointsize $FONT_SIZE -fill black -draw "text $POS_X,$POS_Y \"${1}\" " /home/jenkins/certificate.png /vagrant/out.png -verbose
    sudo convert -pointsize $FONT_SIZE -fill black -draw "text $POS_X,$POS_Y \"$1\" " /home/jenkins/certificate.png /home/jenkins/certificate-$1.png

else
    echo "Positional parameter 1 is empty"
fi

#uncomment the line blow to send messages to you email, remeber mutt must first be configured
#mutt  -s "Jenkins automation booth" $1 -a /vagrant/certificate-$1.png < /vagrant/inventory/templates/msg.txt
# num=$(echo  $1 | awk -F"${try}" '{print NF-2}')
# echo "The number of dots is $num"
#regex for 1 dot before @ symbol back reference the 1st group
#(.+(\.)(\.)?.+)(?=@)
#regex for 2 dot before @ symbol back reference the 1st group
#(.+(\.).+(?=\.)(\.)?.+)(?=@)
