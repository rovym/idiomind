#!/bin/bash
# -*- ENCODING: UTF-8 -*-

source /usr/share/idiomind/ifs/c.conf
source $DS/ifs/mods/cmns.sh
include $DS/ifs/mods/add

if [ "$1" = new_item ]; then

    trgt="$2"
    DMC="$DM_tl/Feeds/cache"
    DCP="$DM_tl/Feeds/.conf"
    fname="$(nmfile "${trgt}")"
    sed -i -e "1i$trgt\\" "$DCP/2.cfg"
    sed -i -e "1i$trgt\\" "$DCP/.22.cfg"
    check_index1 "$DCP/2.cfg" "$DCP/.22.cfg"
    notify-send -i idiomind "$(gettext "Archive")" "$trgt" -t 3000
    exit
        
fi