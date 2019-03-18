#!/bin/bash
# -*- ENCODING: UTF-8 -*-

if [[ "$1" = '_DLG_' ]]; then
    fname="$(basename "$0")"
    name="<b>$(cut -f 1 -d '.' <<< "$fname")</b>"
    icon="$DS/addons/Dics/c.png"
    
    if [ -f "$DC_a/dict/msgs/$fname" ]; then
        info="\n<small>$(gettext "<b>Status:</b>\n") $(< "$DC_a/dict/msgs/$fname")</small>"
        icon="$DS/addons/Dics/a.png"
        
    elif grep -Fxq "$fname" "$DC_a/dict/ok_nolang.list" >/dev/null 2>&1; then
        info="\n<small>$(gettext "<b>Status:</b>\n Not available for the language you are learning.")</small>\n"
        icon="$DS/addons/Dics/b.png"
    fi
    
    source "$DS/ifs/cmns.sh"
    msg "$name\n<small>\n<b>$(gettext "Languages"):</b>\n English, Spanish</small>\n$info" $icon "$4" "$(gettext "Close")"
else

     _test="prueba"
     
    TLANGS="es"
    export TESTURL="http://audio1.spanishdict.com/audio?lang=es&text=${_test}"
    export URL="http://audio1.spanishdict.com/audio?lang=es&text=${word}"
    export EX='mp3'
fi


