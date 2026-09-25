#!/usr/bin/env bash

# Lista os sinks (saídas de áudio) via wpctl
LIST=""
declare -A ID_MAP
declare -A NAME_MAP

ICON_ATIVO=" "   # alto-falante - só aparece na saída atual

while IFS= read -r line; do
  # Linhas de sink têm o formato:  "│  *   50. Nome do dispositivo [vol: 0.40]"
  if [[ "$line" =~ ([0-9]+)\.[[:space:]]+(.+)[[:space:]]+\[vol ]]; then
    ID="${BASH_REMATCH[1]}"
    NAME="${BASH_REMATCH[2]}"
    NAME="${NAME%"${NAME##*[![:space:]]}"}"  # remove espaços à direita
    if [[ "$line" == *'*'* ]]; then
      LABEL="${ICON_ATIVO} ${NAME}"
    else
      LABEL="${NAME}"
    fi
    ID_MAP["$LABEL"]="$ID"
    NAME_MAP["$LABEL"]="$NAME"
    LIST+="$LABEL\n"
  fi
done < <(wpctl status | sed -n '/Sinks:/,/Sources:/p')

LIST="${LIST%\\n}"  # remove a quebra de linha extra do último item

CHOICE=$(echo -e "$LIST" \
  | rofi -dmenu \
         -i \
         -p "Áudio" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 400px;}')

[ -z "$CHOICE" ] && exit 0

SELECTED_ID="${ID_MAP[$CHOICE]}"
[ -z "$SELECTED_ID" ] && exit 0

# Define a saída padrão
wpctl set-default "$SELECTED_ID"

# Se o pactl (compat Pulse) existir, move os streams já em execução também
if command -v pactl &>/dev/null; then
  DEFAULT_SINK=$(pactl get-default-sink 2>/dev/null)
  if [ -n "$DEFAULT_SINK" ]; then
    pactl list short sink-inputs | while read -r STREAM_ID _; do
      pactl move-sink-input "$STREAM_ID" "$DEFAULT_SINK"
    done
  fi
fi

notify-send -u low " Áudio" "Saída alterada para: ${NAME_MAP[$CHOICE]}" 2>/dev/null
