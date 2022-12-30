#!/bin/bash

eww daemon && eww open bar &

em-hypr &
em-wifi &
em-battery &

redshift -PO 4500 &

hyprpaper &

mako &

pkttyagent &

swayidle -w timeout 120 'em-lock' before-sleep 'swaylock -f' & 
