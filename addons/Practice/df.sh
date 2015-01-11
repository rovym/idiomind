#!/bin/bash
# -*- ENCODING: UTF-8 -*-
tpc=$(sed -n 1p ~/.config/idiomind/s/cnfg8)
lgtl=$(sed -n 2p ~/.config/idiomind/s/cnfg10)
lgsl=$(sed -n 2p ~/.config/idiomind/s/cnfg9)
drtt="$HOME/.idiomind/topics/$lgtl/$tpc/words"
drts="/usr/share/idiomind/addons/Practice/"
cd "$HOME/.config/idiomind/topics/$lgtl/$tpc/Practice"

n=1
while [ $n -le $(cat ./fin$1 | wc -l) ]; do
	w1=$(sed -n "$n"p ./fin$1)
	file="$drtt/$w1.mp3"
	tgt="$w1"
	lst=$(eyeD3 "$file" | grep -o -P '(?<=IWI2I0I).*(?=IWI2I0I)')
	if [ $1 = 1 ]; then
	trgt=$(echo "<span font='ultralight'>$tgt</span>")
	[[ $lgsl = Japanese ]] || [[ $lgsl = Chinese ]] || [[ $lgsl = Vietnamese ]] && stgt=? \
	|| stgt="<span color='#949494'><span font='monospace'><b>$(echo "$lst" | tr aeiouy ' ')</b></span></span>"
	elif [ $1 = 2 ]; then
		trgt=$(echo "<span font='ultralight'>$tgt</span>")
		[ $lgsl = Japanese ] || [ $lgsl = Chinese ] || [ $lgsl = Vietnamese ] && stgt="$lst" || stgt="<span color='#949494'><big><b>$lst</b></big></span>"
	fi
	
	if [ -f "$drtt/images/$w1.jpg" ]; then
		IMAGE="$drtt/images/$w1.jpg"
		yad --form --align=center --undecorated \
		--center --on-top --image-on-top --image="$IMAGE" \
		--skip-taskbar --text-align=center --title=" "  \
		--window-icon=idiomind --buttons-layout=edge --borders=0 \
		--field="<big><big><big><big><big><big><big><big><b>$trgt</b></big></big></big></big></big></big></big></big>":lbl \
		--field="$stgt":lbl \
		--button="gtk-close":1 \
		--button="  Got It  ":3 \
		--button="  Nope  ":4 \
		--width=365 --height=300
	else
		yad --form --align=center \
		--center --on-top --image-on-top --undecorated \
		--skip-taskbar --text-align=center --title=" " \
		--window-icon=idiomind --buttons-layout=edge --borders=0 \
		--field="\\n\\n<big><big><big><big><big><big><big><big><b>$trgt</b></big></big></big></big></big></big></big></big>":lbl \
		--field="$stgt\\n\\n\\n":lbl \
		--button="gtk-close":1 \
		--button="  Got It  ":3 \
		--button="  Nope  ":4 \
		--width=365 --height=250
	fi
	ret=$?
	
	if [[ $ret -eq 3 ]]; then
		if [[ $1 = 1 ]]; then
			play $drts/d.mp3 & sed -i 's/'"$w1"'//g' fin.tmp & echo "$w1" >> ./fin.1.ok
		else
			play $drts/d.mp3 & echo "$w1" >> ./fin.2.ok
		fi
	elif [[ $ret -eq 4 ]]; then
		play $drts/d.mp3 & echo "$w1" >> ./fin.$1.no
	else
		$drts/cls "$1" f && break & exit 1
	fi
	let n++
done

