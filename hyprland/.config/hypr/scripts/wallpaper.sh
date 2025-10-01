#!/bin/bash

dir="$HOME/Pictures/wallpapers"

if [ ! -d "$dir" ]; then
  exit 1
fi

monitors=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

walls=($(find "$dir" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \)))

if [ ${#walls[@]} -eq 0 ]; then
    echo "No wallpapers found"
    exit 1
fi

hyprctl hyprpaper unload all

for M in $monitors; do
  rWall="${walls[$RANDOM % ${#walls[@]}]}"
  hyprctl hyprpaper preload "$rWall"
  hyprctl hyprpaper wallpaper "$M,$rWall"
done
