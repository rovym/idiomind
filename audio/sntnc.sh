#!/bin/bash
topic=$(sed -n 1p ~/.config/idiomind/s/cnfg8)
lngt=$(sed -n 2p ~/.config/idiomind/s/cnfg10)
lngs=$(sed -n 2p ~/.config/idiomind/s/cnfg9)
DIR1="$HOME/.idiomind/topics/$lngt/$topic"

if [[ "$(ps -A | grep -Fxo "wrds.sh")" = "wrds.sh" ]]; then
    exit 1

else
sleep 0.3
    #if [[ "$(ps -A | grep -o "play")" = "play" ]]; then
	#exit 1
    #fi

    play "$DIR1/$1.mp3" & sleep 0.2 && exit 1
fi
