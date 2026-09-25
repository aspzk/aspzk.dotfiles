#!/usr/bin/env bash

CHOICE=$(cliphist list \
  | rofi -dmenu \
         -i \
         -p "Clipboard" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 600px;}')

[ -z "$CHOICE" ] && exit 0

echo "$CHOICE" | cliphist decode | wl-copy
