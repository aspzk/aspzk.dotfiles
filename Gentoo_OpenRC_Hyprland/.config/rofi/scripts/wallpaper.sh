#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/sda/Imagens/wallpapers"

# Busca imagens recursivamente nas subpastas
CHOICE=$(find "$WALLPAPER_DIR" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) \
  | sed "s|$WALLPAPER_DIR/||" \
  | sort \
  | rofi -dmenu \
         -i \
         -p "Wallpaper" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 600px;}')

[ -z "$CHOICE" ] && exit 0

FILE="$WALLPAPER_DIR/$CHOICE"

awww img "$FILE" \
  --transition-type fade \
  --transition-duration 1.5 \
  --transition-fps 60
