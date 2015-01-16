#!/bin/bash
# -*- ENCODING: UTF-8 -*-

source /usr/share/idiomind/ifs/trans/es/others.conf
IMAGE=/usr/share/idiomind/ifs/1u.png

drtf="/usr/share/idiomind/addons/Learning with news/examples/"
user=$(echo "$(whoami)")
if [ "$1" = s ]; then
	ins="--field=<small><b> $no_language1</b></small>\\t\\t:lbl"
elif [ "$1" = t ]; then
	int="--field=<small><b> $no_language2</b></small>\\t\\t:lbl"
elif [ "$1" = n ]; then
	int="--field=<small><b> $no_language3</b></small>\\t\\t:lbl"
fi

dialog=$(yad --center --width=520 --height=300 --fixed \
	--image-on-top --on-top --class=idiomind --name=idiomind \
	--window-icon=idiomind --buttons-layout=end --image=$IMAGE  \
	--title="Idiomind" --form --borders=10 --align=right --button=Ok:0 \
	--field="<small>\\t\\t\\t\\t$language_target : </small>:CB" \
	!"English!French!German!Italian!Japanese!Portuguese!Spanish!Vietnamese!Chinese!"\
	--field="<small>\\t\\t\\t\\t$language_source : </small>:CB" \
	!"English!French!German!Italian!Japanese!Portuguese!Russian!Spanish!Vietnamese!Chinese" \
	"$ins" "$int" --field=":lbl")

ret=$?

if [[ $ret -eq 1 ]]; then
	killall 1u & exit 1

elif [[ $ret -eq 0 ]]; then
	source=$(echo "$dialog" | cut -d "|" -f1)
	target=$(echo "$dialog" | cut -d "|" -f2)
	
	if [ -z "$dialog" ]; then
		/usr/share/idiomind/ifs/1u n & exit 1
	elif [ -z $source ]; then
		/usr/share/idiomind/ifs/1u s & exit 1
	elif [ -z $target ]; then
		/usr/share/idiomind/ifs/1u t & exit 1
	fi
	
	mkdir "$HOME"/.idiomind/
	
	if [ $? -ne 0 ]; then
		yad --name=idiomind \
		--image=error --button=gtk-ok:1\
		--text=" <b>$write_err /home/$user/</b>\\n" \
		--image-on-top --sticky --fixed \
		--width=320 --height=80 \
		--borders=2 --title=Idiomind \
		--skip-taskbar --center \
		--window-icon=idiomind & exit 1
	fi
	
	mkdir "$HOME"/.idiomind/topics
	mkdir "$HOME"/.idiomind/topics/saved
	DIR1="$HOME"/.idiomind/topics
	[ ! -d  "$HOME"/.config ] && mkdir "$HOME"/.config
	mkdir "$HOME"/.config/idiomind
	DIR2="$HOME"/.config/idiomind
	mkdir "$DIR2"/s
	mkdir "$DIR2"/addons
	mkdir "$DIR2"/addons/new
	mkdir "$DIR2"/addons/stats
	mkdir "$DIR2"/addons/dict
	mkdir "$DIR2"/addons/practice
	mkdir "$DIR2"/topics
	DIR3="$HOME"/.config/idiomind/topics
	mkdir "$HOME/.config/idiomind/addons/Learning with news"
	DIR4="$HOME/.config/idiomind/addons/Learning with news"
	cp -f /usr/share/idiomind/default/new/* $DIR2/addons/new
	cp -f -r /usr/share/idiomind/default/dicts/* $DIR2/addons/dict
	
	if echo "$target" | grep "English"; then
		echo "en" > $DIR2/s/cnfg9
		echo "english" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "French"; then
		echo "fr" > $DIR2/s/cnfg9
		echo "french" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "German"; then
		echo "de" > $DIR2/s/cnfg9
		echo "german" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Italian"; then
		echo "it" > $DIR2/s/s/cnfg9
		echo "italian" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Japanese"; then
		echo "ja" > $DIR2/s/cnfg9
		echo "japanese" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Portuguese"; then
		echo "pt" > $DIR2/s/cnfg9
		echo "portuguese" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Spanish"; then
		echo "es" > $DIR2/s/cnfg9
		echo "spanish" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Vietnamese"; then
		echo "vi" > $DIR2/s/cnfg9
		echo "vietnamese" >> $DIR2/s/cnfg9
	fi
	
	
	if echo "$target" | grep "Chinese"; then
		echo "zh-cn" > $DIR2/s/cnfg9
		echo "Chinese" >> $DIR2/s/cnfg9
	fi
	
	if echo "$target" | grep "Russian"; then
		echo "ru" > $DIR2/s/cnfg9
		echo "Russian" >> $DIR2/s/cnfg9
	fi
	
	if echo "$source" | grep "English"; then
		if [ ! -d "$DIR1"/English ]; then
			mkdir "$DIR1"/English
			mkdir "$DIR1"/English/.share
			mkdir "$DIR3"/English
			mkdir "$DIR4"/English
			mkdir "$DIR4"/English/subscripts
			cp -f "$drtf"/English "$DIR4"/English/subscripts/Example
		fi
		echo "en" > $DIR2/s/cnfg10
		echo "English" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "French"; then
		if [ ! -d "$DIR1"/French ]; then
			mkdir "$DIR1"/French
			mkdir "$DIR1"/French/.share
			mkdir "$DIR3"/French
			mkdir "$DIR4"/French
			mkdir "$DIR4"/French/subscripts
			cp -f "$drtf"/French "$DIR4"/French/subscripts/Example
		fi
		echo "fr" > $DIR2/s/cnfg10
		echo "French" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "German"; then
		if [ ! -d "$DIR1"/German ]; then
			mkdir "$DIR1"/German
			mkdir "$DIR1"/German/.share
			mkdir "$DIR3"/German
			mkdir "$DIR4"/German
			mkdir "$DIR4"/German/subscripts
			cp -f "$drtf"/German "$DIR4"/German/subscripts/Example
		fi
		echo "de" > $DIR2/s/cnfg10
		echo "German" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Italian"; then
		if [ ! -d "$DIR1"/Italian ]; then
			mkdir "$DIR1"/Italian
			mkdir "$DIR1"/Italian/.share
			mkdir "$DIR3"/Italian
			mkdir "$DIR4"/Italian
			mkdir "$DIR4"/Italian/subscripts
			cp -f "$drtf"/Italian "$DIR4"/Italian/subscripts/Example
		fi
		echo "it" > $DIR2/s/cnfg10
		echo "Italian" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Japanese"; then
		if [ ! -d "$DIR1"/Japanese ]; then
			mkdir "$DIR1"/Japanese
			mkdir "$DIR1"/Japanese/.share
			mkdir "$DIR3"/Japanese
			mkdir "$DIR4"/Japanese
			mkdir "$DIR4"/Japanese/subscripts
			cp -f "$drtf"/Japanese "$DIR4"/Japanese/subscripts/Example
		fi
		echo "ja" > $DIR2/s/cnfg10
		echo "Japanese" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Portuguese"; then
		if [ ! -d "$DIR1"/Portuguese ]; then
			mkdir "$DIR1"/Portuguese
			mkdir "$DIR1"/Portuguese/.share
			mkdir "$DIR3"/Portuguese
			mkdir "$DIR4"/Portuguese
			mkdir "$DIR4"/Portuguese/subscripts
			cp -f "$drtf"/Portuguese "$DIR4"/Portuguese/subscripts/Example
		fi
		echo "pt" > $DIR2/s/cnfg10
		echo "Portuguese" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Spanish"; then
		if [ ! -d "$DIR1"/Spanish ]; then
			mkdir "$DIR1"/Spanish
			mkdir "$DIR1"/Spanish/.share
			mkdir "$DIR3"/Spanish
			mkdir "$DIR4"/Spanish
			mkdir "$DIR4"/Spanish/subscripts
			cp -f "$drtf"/Spanish "$DIR4"/Spanish/subscripts/Example
		fi
		echo "es" > $DIR2/s/cnfg10
		echo "Spanish" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Chinese"; then
		if [ ! -d "$DIR1"/Chinese ]; then
			mkdir "$DIR1"/Chinese
			mkdir "$DIR1"/Chinese/.share
			mkdir "$DIR3"/Chinese
			mkdir "$DIR4"/Chinese
			mkdir "$DIR4"/Chinese/subscripts
			cp -f "$drtf"/Chinese "$DIR4"/Chinese/subscripts/Example
		fi
		echo "zh-cn" > $DIR2/s/cnfg10
		echo "Chinese" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Vietnamese"; then
		if [ ! -d "$DIR1"/Vietnamese ]; then
			mkdir "$DIR1"/Vietnamese
			mkdir "$DIR1"/Vietnamese/.share
			mkdir "$DIR3"/Vietnamese
			mkdir "$DIR4"/Vietnamese
			mkdir "$DIR4"/Vietnamese/subscripts
			cp -f "$drtf"/Vietnamese "$DIR4"/Vietnamese/subscripts/Example
		fi
		echo "vi" > $DIR2/s/cnfg10
		echo "Vietnamese" >> $DIR2/s/cnfg10
	fi
	
	if echo "$source" | grep "Russian"; then
		if [ ! -d "$DIR1"/Russian ]; then
			mkdir "$DIR1"/Russian
			mkdir "$DIR1"/Russian/.share
			mkdir "$DIR3"/Russian
			mkdir "$DIR4"/Russian
			mkdir "$DIR4"/Russian/subscripts
			cp -f "$drtf"/Russian "$DIR4"/Russian/subscripts/Example
		fi
		echo "ru" > $DIR2/s/cnfg10
		echo "Russian" >> $DIR2/s/cnfg10
	fi
	
	b=$(tr -dc a-z < /dev/urandom | head -c 1)
	c=$(echo $(($RANDOM%100)))
	echo $c$b > $DIR2/s/cnfg4
	cp /usr/share/idiomind/default/cnfg1 \
	"$HOME/.config/idiomind/s/cnfg1"
	touch $DIR2/s/cnfg8
	touch $DIR2/s/cnfg6
	touch "$DIR4/.cnf"
	touch $DIR2/addons/stats/cnf
	touch $DIR2/s/cnfg12
	#/usr/share/idiomind/mngr.sh mkmn
	exit 1
else
	killall 1u & exit 1
fi