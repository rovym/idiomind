#!/bin/bash

DC_a="$HOME/.config/idiomind/addons"
if [ ! -f "$DC_a/gts.cfg" ] || [[ -z "$(< "$DC_a/gts.cfg")" ]]; then
echo -e "key=\"\"" > "$DC_a/gts.cfg"; fi
key=$(grep -o key=\"[^\"]* "$DC_a/gts.cfg" |grep -o '[^"]*$')
c=$(yad --form --title="$(gettext "Google Translate")" \
--name=Idiomind --class=Idiomind \
--window-icon="$DS/images/icon.png" --center \
--on-top --skip-taskbar --expand-column=3 \
--width=450 --height=300 --borders=10 \
--always-print-result --editable --print-all \
--field="$(gettext "Key (optional)")":TXT "$key" \
--field="\n<a href='http://translate.google.com/community?source=all'>\
$(gettext "Help improve Google Translate")</a>\n\n":LBL " " \
--button="$(gettext "Cancel")":1 \
--button="$(gettext "OK")":0)
ret=$?
if [ $ret = 0 ]; then
val2="$(cut -d "|" -f1 <<<"$c")"
sed -i "s/key=.*/key=\"$val2\"/g" "$DC_a/gts.cfg"
fi