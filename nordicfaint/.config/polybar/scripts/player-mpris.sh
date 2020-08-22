#!/bin/bash

status=$(playerctl status 2> /dev/null)

if [ "$status" = "Playing" ]; then
    label=$(playerctl metadata --format '{{ artist }} - {{ title }}')
elif [ "$status" = "Paused" ]; then
    label=$(playerctl metadata --format ' {{ artist }} - {{ title }}')
else
    label=""
fi

echo $label
