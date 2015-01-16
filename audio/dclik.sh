#!/bin/bash

lgtl=$(sed -n 2p ~/.config/idiomind/s/cnfg10)
DM_tl="$HOME/.idiomind/topics/$lgtl"

wdr=$(echo "$1" | awk '{print tolower($0)}')
play "$DM_tl/.share/$wdr".mp3
exit