#! /bin/bash

read -p "Are you using Flatpak for Inkscape? (y/n): " use_flatpak
case "$use_flatpak" in 
    y|Y ) INKSCAPE="flatpak run org.inkscape.Inkscape";;
    n|N ) INKSCAPE="/usr/bin/inkscape";;
    * ) echo "Invalid choice. Defaulting to /usr/bin/inkscape"; INKSCAPE="/usr/bin/inkscape";;
esac

read -p "Do you want to overwrite existing files? (y/n): " overwrite_choice
case "$overwrite_choice" in 
    y|Y ) OVERWRITE=true;;
    n|N ) OVERWRITE=false;;
    * ) echo "Invalid choice. Defaulting to not overwrite"; OVERWRITE=false;;
esac

ZOPFLIPNG="/usr/bin/zopflipng"

SRC_FILE="assets.svg"
ASSETS_DIR="../skin"
INDEX="assets.txt"

for i in `cat $INDEX`
do 
    OUTPUT_FILE="$ASSETS_DIR/$i.png"
    if [ -f "$OUTPUT_FILE" ] && [ "$OVERWRITE" = false ]; then
        echo "Skipping $OUTPUT_FILE"
        continue
    fi

    echo
    echo Rendering $OUTPUT_FILE
    $INKSCAPE --export-id=$i \
              --export-id-only \
              --export-background-opacity=0 \
              --export-area-drawing \
              --export-type="png" \
              --export-filename $OUTPUT_FILE \
              $SRC_FILE >/dev/null \
    && $ZOPFLIPNG -ym $OUTPUT_FILE $OUTPUT_FILE
done
exit 0