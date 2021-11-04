#!/bin/bash
BATTERY_STATUS=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | pcregrep -o1 'state:\s+([^\s]+)')
BATTERY_PERCENTAGE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | pcregrep -o1 'percentage:\s+(\d+)')

if [ "$(pactl get-sink-mute @DEFAULT_SINK@)" == "Mute: no" ]; then
    SINK_PREFIX="Volume: "
else
    SINK_PREFIX="Vol[M]: "
fi

if [ "$(pactl get-source-mute @DEFAULT_SOURCE@)" == "Mute: no" ]; then
    SOURCE_PREFIX="Record: "
else
    SOURCE_PREFIX="Rec[M]: "
fi

SINK_VOL="$(printf "% 3d%%" $(pactl get-sink-volume @DEFAULT_SINK@ toggle | head -n1 | cut -d/ -f 2 | tr -d '[:space:]%'))"
SOURCE_VOL="$(printf "% 3d%%" $(pactl get-source-volume @DEFAULT_SOURCE@ toggle | head -n1 | cut -d/ -f 2 | tr -d '[:space:]%'))"

echo \
    "Battery ($BATTERY_STATUS): $BATTERY_PERCENTAGE% |" \
    "$SINK_PREFIX$SINK_VOL |" \
    "$SOURCE_PREFIX$SOURCE_VOL |" \
    $(date +'%Y-%m-%d %l:%M:%S %p')
