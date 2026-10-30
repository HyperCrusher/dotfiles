#!/bin/bash

wallDir="$HOME/Pictures/wallpapers"

if [ ! -d "$wallDir" ]; then
    echo "Wallpaper directory not found: $wallDir" >&2
    exit 1
fi

mapfile -t monitors < <(hyprctl monitors -j | jq -r '.[].name')
mapfile -d '' walls < <(find "$wallDir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -print0)

if [ ${#walls[@]} -eq 0 ]; then
    exit 1
fi

for monitor in "${monitors[@]}"; do
    randomWall="${walls[RANDOM % ${#walls[@]}]}"
    hyprctl hyprpaper wallpaper "$monitor,$randomWall"
done
