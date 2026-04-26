#!/bin/bash

# if imagemagick convert is not called convert, change to the correct binary
IMAGIK=convert

function syntax() {
    echo "Usage: splitimage <extension> <width>"
    echo -e "\teg. splitimage png 120"
    echo ""
    exit 1
}

if [[ -z "$1" ]]; then
    echo "Error: missing File extension"
    syntax
fi

if [[ -z "$2" ]]; then
    echo "Error: missing image width"
    syntax
fi

EXT=$1
WIDTH=$2

ls -1 *.${EXT} | while read filename;
do
    FILE_W=$(file ${filename} | cut -d' ' -f5)
    PARTS=$(echo $FILE_W / $WIDTH | bc)
    echo "$filename has $PARTS frames"
done

echo ""
read -p " * If the above looks acceptable, press enter, otherwise CTRL C to quit the script"

echo ""


ls -1 *.${EXT} | while read filename;
do
    FILE_W=$(file ${filename} | cut -d' ' -f5)
    PARTS=$(echo $FILE_W / $WIDTH | bc)
    $IMAGIK ${filename} +repage -crop ${PARTS}x1@ s${filename}_%02d.${EXT}
done
