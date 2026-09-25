#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE="$SCREENSHOT_DIR/screenshot_$TIMESTAMP.png"

OPTIONS=" Tela inteira\n Região\n Janela ativa\n Tela inteira (5s)\n Região (5s)"

CHOICE=$(echo -e "$OPTIONS" \
  | rofi -dmenu \
         -i \
         -p "Screenshot" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 260px;}')

case "$CHOICE" in
  " Tela inteira")
    grim "$FILE"
    ;;
  " Região")
    grim -g "$(slurp)" "$FILE"
    ;;
  " Janela ativa")
    FOCUSED=$(swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
    grim -g "$FOCUSED" "$FILE"
    ;;
  " Tela inteira (5s)")
    sleep 5 && grim "$FILE"
    ;;
  " Região (5s)")
    REGION=$(slurp)
    sleep 5 && grim -g "$REGION" "$FILE"
    ;;
  *) exit 1 ;;
esac

# Notificação e cópia para clipboard
if [ -f "$FILE" ]; then
  wl-copy < "$FILE"
  notify-send "Screenshot" "Salvo em $FILE\n(copiado para o clipboard)" \
    --icon="$FILE" \
    --expire-time=4000
fi
