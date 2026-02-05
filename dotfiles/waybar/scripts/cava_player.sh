#!/bin/bash

# ------------ BARRAS OPTIMIZADAS (CAVA RAW + SED) -----------------

bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

bar_length=${#bar}

# Sustitución eficiente para convertir números 0..7 en barras Unicode
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
framerate = 60
bars = 14

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

pkill -f "cava -p $config_file"

# ------------ LOOP PRINCIPAL -----------------

cava -p "$config_file" | sed -u "$dict" | while read -r eq; do

    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)

    if [[ -z "$artist" && -z "$title" ]]; then
        echo "󰎇 Nothing playing | $eq"
    else
        echo "󰎈 $artist — $title  |  $eq"
    fi

done

