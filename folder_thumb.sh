#!/bin/bash
set -euo pipefail

# paths
SOURCE_DIR="./images/source"
TEMP_DIR="./images/temp"
MERGED_DIR="./images/merged"
BASE_PNG="./images/base.png"

# Convert JPEG files to PNG and remove original JPEG files
for icon in "$SOURCE_DIR"/*.{jpg,jpeg}; do
    if [ -f "$icon" ]; then
        convert "$icon" -dither FloydSteinberg -colors 256 -quality 9 -interlace Plane "${icon%.*}.png" && rm "$icon"
        echo "$icon converted to PNG and removed."
    fi
done

# Resize images and move them to temp directory
for icon in "$SOURCE_DIR"/*.png; do
    if [ -f "$icon" ]; then
        # Get the width and height of the image
        dimensions=$(identify -format "%w %h" "$icon")
        read -r width height <<< "$dimensions"

        # Check if both dimensions are smaller than 2000px
        if [ "$width" -lt 1000 ] && [ "$height" -lt 1000 ]; then
            mv "$icon" "$TEMP_DIR/"
            echo "$icon moved to /temp."
            continue
        fi

        # Determine which dimension is longer
        if [ "$width" -ge "$height" ]; then
            # Landscape image, scale width to 1000px
            new_width=1000
            new_height=$((height * new_width / width))
        else
            # Portrait image, scale height to 1000px
            new_height=1000
            new_width=$((width * new_height / height))
        fi

        # Resize the image while maintaining aspect ratio
        convert "$icon" -resize "${new_width}x${new_height}" -dither FloydSteinberg -colors 256 -quality 9 -interlace Plane "$TEMP_DIR/$(basename "$icon")" && rm "$icon"
        echo "$icon resized and saved successfully."
    fi
done

# Update directories
ls ./images/source >/dev/null
ls ./images/temp >/dev/null
ls ./images/merged >/dev/null

# Loop through each PNG file in the temp directory
for icon in "$TEMP_DIR"/*.png; do
    # Get the base name of the icon file
    icon_basename=$(basename "$icon")

    # Construct the output file path
    output_file="$MERGED_DIR/${icon_basename}"

    # Check if the output file already exists
    if [ ! -f "$output_file" ]; then
        # Get the dimensions of the icon
        dimensions=$(identify -format "%wx%h" "$icon")
        # Extract width and height
        width=$(echo "$dimensions" | cut -d'x' -f1)
        height=$(echo "$dimensions" | cut -d'x' -f2)

        # Determine the longer side
        if [ "$width" -gt "$height" ]; then
            # If width is longer, scale width to 200 pixels
            convert "$BASE_PNG" \( "$icon" -resize "220x" \) -gravity center -composite -compose over -alpha set "$output_file"
            echo "Merged $icon_basename"
        else
            # If height is longer or they are equal, scale height to 200 pixels
            convert "$BASE_PNG" \( "$icon" -resize "x220" \) -gravity center -composite -compose over -alpha set "$output_file"
            echo "Merged $icon_basename"
        fi
    fi
done

echo "All icons merged!"