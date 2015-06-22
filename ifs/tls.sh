#!/bin/bash
# -*- ENCODING: UTF-8 -*-

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
[ -z "$DM" ] && source /usr/share/idiomind/ifs/c.conf
source "$DS/ifs/mods/cmns.sh"
lgt=$(lnglss "$lgtl")
lgs=$(lnglss "$lgsl")

restoresin() {

    > "$DC_tlt/1.cfg"; > "$DC_tlt/2.cfg"
    > "$DC_tlt/3.cfg"; > "$DC_tlt/4.cfg"
    
    while read item_; do
    item="$(sed 's/},/}\n/g' <<<"${item_}")"
    type="$(grep -oP '(?<=type={).*(?=})' <<<"${item}")"
    trgt="$(grep -oP '(?<=trgt={).*(?=})' <<<"${item}")"
    
    if [ -n "${trgt}" ]; then
    if [[ ${type} = 1 ]]; then
    echo "${trgt}" >> "$DC_tlt/3.cfg"
    else echo "${trgt}" >> "$DC_tlt/4.cfg"; fi
    echo "${trgt}" >> "$DC_tlt/1.cfg"
    fi
    
    done < "$DC_tlt/0.cfg"
}

function check_source_1() {
CATEGORIES="others
comics
culture
family
entertainment
grammar
history
documentary
in_the_city
movies
internet
music
nature
news
office
relations
sport
social_networks
shopping
technology
travel
article
science
interview
funny"

sets=('v' 'tname' \
'langs' 'langt' \
'authr' 'cntct' 'ctgry' 'ilink' \
'datec' 'dateu' 'datei' \
'nword' 'nsent' 'nimag' \
'level' 'set_1' 'set_2')

LANGUAGES="English
Chinese
French
German
Italian
Japanese
Portuguese
Russian
Spanish
Vietnamese"

    dir="${1}"
    file="${1}"
    nu='^[0-9]+$'
    
    invalid() {
        exit=1
        msg "$1. $(gettext "File is corrupted.")\n" error & exit 1
    }
    
    [ ! -f "${file}" ] && invalid
    n=0; exit=0
    while read -r line; do
    
        if [ -z "$line" ]; then continue; fi
        get="${sets[$n]}"
        val=$(echo "${line}" |grep -o "$get"=\"[^\"]* |grep -o '[^"]*$')
        if [[ $n = 1 ]]; then
        if [ -z "${val}" ] || [ ${#val} -gt 60 ] || \
        [ `grep -o -E '\*|\/|\@|$|\)|\(|=|-' <<<"${val}"` ]; then invalid 2; fi
        elif [[ $n = 2 || $n = 3 ]]; then
        if ! grep -Fox "${val}" <<<"${LANGUAGES}"; then invalid 3; fi
        elif [[ $n = 4 || $n = 5 ]]; then
        if [ ${#val} -gt 30 ] || \
        [ `grep -o -E '\*|\/|$|\)|\(|=' <<<"${val}"` ]; then invalid 4; fi
        elif [[ $n = 6 ]]; then
        if ! grep -Fox "${val}" <<<"${CATEGORIES}"; then invalid 5; fi
        elif [[ $n = 7 ]]; then
        if [ ${#val} -gt 4 ]; then invalid 6; fi
        elif [[ $n = 8 || $n = 9 || $n = 10 ]]; then
        if [ -n "${val}" ]; then
        if ! [[ ${val} =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] \
        || [ ${#val} -gt 12 ]; then invalid 7; fi; fi
        elif [[ $n = 11 || $n = 12 || $n = 13 ]]; then
        if ! [[ $val =~ $nu ]] || [ ${val} -gt 200 ]; then invalid 8; fi
        elif [[ $n = 14 ]]; then
        if ! [[ $val =~ $nu ]] || [ ${#val} -gt 2 ]; then invalid 9; fi
        fi
        export ${sets[$n]}="${val}"
        let n++
         
    done < <(head -n 15 < "${file}")

    if [[ $exit = 0 ]] ; then
    > "$DT/${2}.cfg"
    fi
}

details() {
    
    cd "$2"
    dirs="$(find . -maxdepth 5 -type d)"
    files="$(find . -type f -exec file {} \; 2> /dev/null)"
    hfiles="$(ls -d ./.[^.]* | less)"
    exfiles="$(find . -maxdepth 5 -perm -111 -type f)"
    attchsdir="$(cd "./files/"; find . -maxdepth 5 -type f)"
    wcdirs=`sed '/^$/d' <<<"${dirs}" | wc -l`
    wcfiles=`sed '/^$/d' <<<"${files}" | wc -l`
    wchfiles=`sed '/^$/d' <<<"${hfiles}" | wc -l`
    wcexfiles=`sed '/^$/d' <<<"${exfiles}" | wc -l`
    others=$((wchfiles+wcexfiles))
    SRFL1=$(cat "./conf/id.cfg")
    SRFL2=$(cat "./conf/info")
    SRFL5=$(cat "./conf/0.cfg")
    

    echo -e "
$(gettext "SUMMARY")

Directories: $wcdirs
Files: $wcfiles
Others files: $others

$(gettext "FILES")

$files
$attchsdir

$hfiles

$exfiles

$(gettext "TEXT FILES")

$SRFL1

$SRFL2

$SRFL5" | yad --text-info --title="$(gettext "Installation details")" \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" \
    --fontname='monospace 9' --margins=10 \
    --scroll --center \
    --width=340 --height=280 --borders=0 \
    --button="$(gettext "Open Folder")":"xdg-open '$2'" \
    --button="$(gettext "Close")":0
} >/dev/null 2>&1


check_index() {

    DC_tlt="$DM_tl/${2}/.conf"
    DM_tlt="$DM_tl/${2}"
    nv=0; f=0
    
    _check() {
        
        if [ ! -d "${DC_tlt}" ]; then mkdir "${DC_tlt}"; fi
        n=0
        while [[ $n -le 6 ]]; do
            [ ! -f "${DC_tlt}/$n.cfg" ] && touch "${DC_tlt}/$n.cfg"
            if grep '^$' "${DC_tlt}/$n.cfg"; then
            sed -i '/^$/d' "${DC_tlt}/$n.cfg"; fi
            check_index1 "${DC_tlt}/$n.cfg"
            ((n=n+1))
        done
        
        if [ -n "$(< "${DC_tlt}/0.cfg")" ]; then
        if ! grep '},trgt={' "${DC_tlt}/0.cfg"; then
        eval nv=1; fi; fi
        
        if [ ! -f "${DC_tlt}/8.cfg" ]; then
        echo 1 > "${DC_tlt}/8.cfg"; fi
        eval stts=$(sed -n 1p "${DC_tlt}/8.cfg")
    }
    
    _restore() {
    
        rm "$DC_tlt/0.cfg" "$DC_tlt/1.cfg" \
        "$DC_tlt/3.cfg" "$DC_tlt/4.cfg"

        while read item_; do
        item="$(sed 's/},/}\n/g' <<<"${item_}")"
        type="$(grep -oP '(?<=type={).*(?=})' <<<"${item}")"
        trgt="$(grep -oP '(?<=trgt={).*(?=})' <<<"${item}")"
        
        if [ -n "${trgt}" ]; then
        if [[ ${type} = 1 ]]; then
        echo "${trgt}" >> "$DC_tlt/3.cfg"
        else echo "${trgt}" >> "$DC_tlt/4.cfg"; fi
        echo "${trgt}" >> "$DC_tlt/1.cfg"
        fi
        
        done < "$DC_tlt/0.cfg"
    }

    _sanity() {

        cfg11="$2"
        sed -i '/^$/d' "${cfg11}"
        n=1
        while [[ $n -le 200 ]]; do
            line=$(sed -n ${n}p "${cfg11}" | sed -n 's/^\([0-9]*\)[:].*/\1/p')
            if [ -z ${line} ]; then
                echo "$n:[type={},trgt={},srce={},exmp={},defn={},note={},wrds={},grmr={},].[tag={},mark={},].id=[]" >> "${cfg11}"
            elif [[ ${line} != ${n} ]]; then
                sed -i ""$n"s|"$line"\:|"$n"\:|g" "${cfg11}"
            fi
            let n++
        done
    }
    
    _new_version() {
    
        mv -f "$DC_tlt/0.cfg" "$DC_tlt/1.cfg"
        rm "$DC_tlt/2.cfg" "$DC_tlt/.11.cfg"
        if [ ! -d "${DM_tlt}/images" ]; then
        mkdir "${DM_tlt}/images"; fi
        touch "$DC_tlt/2.cfg"
        > "$DC_tlt/0.cfg"
        
        n=1
        while [[ $n -le 200 ]]; do
        
            unset id type trgt srce exmp dftn note tag lwrd grmr
            item="$(sed -n ${n}p "$DC_tlt/1.cfg")"
            if [ -z "$item" ]; then break; fi
            fname="$(echo -n "${item}" | md5sum | rev | cut -c 4- | rev)"

            if [ -f "${DM_tlt}/$fname.mp3" ]; then
            tgs=$(eyeD3 "${DM_tlt}/$fname.mp3")
            trgt=$(grep -o -P "(?<=ISI1I0I).*(?=ISI1I0I)" <<<"$tgs")
            srce=$(grep -o -P "(?<=ISI2I0I).*(?=ISI2I0I)" <<<"$tgs")
            grmr="$(grep -o -P '(?<=IGMI3I0I).*(?=IGMI3I0I)' <<<"${tgs}")"
            lwrd="$(grep -o -P '(?<=IPWI3I0I).*(?=IPWI3I0I)' <<<"${tgs}")"
            type=2
            id="$(set_name_file "${type}" "${trgt}" "${srce}" "${exmp}" "${dftn}" "${note}" "${lwrd}" "${grmr}")"
            mv -f "${DM_tlt}/$fname.mp3" "${DM_tlt}/$id.mp3"
            
            elif [ -f "${DM_tlt}/words/$fname.mp3" ]; then
            tgs=$(eyeD3 "${DM_tlt}/words/$fname.mp3")
            trgt=$(grep -o -P "(?<=IWI1I0I).*(?=IWI1I0I)" <<<"$tgs")
            srce=$(grep -o -P "(?<=IWI2I0I).*(?=IWI2I0I)" <<<"$tgs")
            fields="$(grep -o -P '(?<=IWI3I0I).*(?=IWI3I0I)' <<<"${tgs}" | tr '_' '\n')"
            mark="$(grep -o -P '(?<=IWI4I0I).*(?=IWI4I0I)' <<<"${tgs}")"
            exmp="$(sed -n 1p <<<"${fields}")"
            dftn="$(sed -n 2p <<<"${fields}")"
            note="$(sed -n 3p <<<"${fields}")"
            type=1
            id="$(set_name_file "${type}" "${trgt}" "${srce}" "${exmp}" "${dftn}" "${note}" "${lwrd}" "${grmr}")"
            mv -f "${DM_tlt}/words/$fname.mp3" "${DM_tlt}/$id.mp3"
            fi
            
            if [ -f "${DM_tlt}/words/images/$fname.jpg" ]; then
            mv -f "${DM_tlt}/words/images/$fname.jpg" "${DM_tlt}/images/$id.jpg"
            fi
            
            echo "$n:[type={$type},trgt={$trgt},srce={$srce},exmp={$exmp},defn={$dftn},note={$note},wrds={$lwrd},grmr={$grmr},].[tag={$tag},mark={$mark},].id=[$id]" >> "$DC_tlt/0.cfg"
            let n++
        done
        
        if [ -f "${DM_tlt}/words/images/img.jpg" ]; then
        mv "${DM_tlt}/words/images/img.jpg" "${DM_tlt}/images/img.jpg"; fi
        if [ -d "${DM_tlt}/words" ]; then rm -r "${DM_tlt}/words"; fi
    }
    
    fix() {
        
        if [ $? -ne 0 ]; then
        [ -f "$DT/ps_lk" ] && rm -f "$DT/ps_lk"
        msg "$(gettext "File not found")\n" error & exit 1; fi
        
        if [ "$stts" = 13 ]; then
            if [ -f "$DC_tlt/8.cfg_" ] && \
            [ -n $(< "$DC_tlt/8.cfg_") ]; then
            stts=$(sed -n 1p "$DC_tlt/8.cfg_")
            rm "$DC_tlt/8.cfg_"
            else stts=1; fi
            echo "$stts" > "$DC_tlt/8.cfg"
        fi
    }
    
    _check
    
    if [ ${f} = 1 ] || [ ${nv} = 1 ]; then
    
        if [ ${f} = 1 ]; then
        (sleep 1
        notify-send -i idiomind "$(gettext "Index Error")" \
        "$(gettext "Fixing...")" -t 3000) &
        > "$DT/ps_lk"
        [ ! -d "$DM_tlt/.conf" ] && mkdir "$DM_tlt/.conf"
        DC_tlt="$DM_tlt/.conf"
        fi
        
        if [ ${nv} = 1 ]; then
        (sleep 1
        notify-send -i idiomind "$(gettext "Fixing index")" \
        "$(gettext "Migrating to new version...")" -t 3000) &
        > "$DT/ps_lk"
        _new_version
        fi
        
        "$DS/ifs/tls.sh" colorize
        "$DS/mngr.sh" mkmn
    fi
    
    exit
}

add_audio() {

    cd "$HOME"
    AU=$(yad --file --title="$(gettext "Add Audio")" \
    --text=" $(gettext "Browse to and select the audio file that you want to add.")" \
    --class=Idiomind --name=Idiomind \
    --file-filter="*.mp3" \
    --window-icon="$DS/images/icon.png" --center --on-top \
    --width=620 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)
    ret=$?
    
    audio=$(cut -d "|" -f1 <<<"$AU")
    DT="$2"; cd "$DT"
    if [[ $ret -eq 0 ]]; then
    if [ -f "${audio}" ]; then cp -f "${audio}" "$DT/audtm.mp3"; fi
    fi
} >/dev/null 2>&1

edit_audio() {

    cmd="$(sed -n 16p $DC_s/1.cfg)"
    (cd "$3"; "$cmd" "$2") & exit
}

text() {

    yad --form --title="$(gettext "Info")" \
    --name=Idiomind --class=Idiomind \
    --window-icon="$DS/images/icon.png" \
    --scroll --fixed --center --on-top \
    --width=300 --height=250 --borders=5 \
    --field="$(< "$2")":lbl \
    --button="$(gettext "Close")":0
} >/dev/null 2>&1


add_file() {

    cd "$HOME"
    FL=$(yad --file --title="$(gettext "Add File")" \
    --text=" $(gettext "Browse to and select the file that you want to add.")" \
    --name=Idiomind --class=Idiomind \
    --file-filter="*.mp3 *.ogg *.mp4 *.m4v *.jpg *.jpeg *.png *.txt *.pdf *.gif" \
    --add-preview --multiple \
    --window-icon="$DS/images/icon.png" --on-top --center \
    --width=680 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)
    ret=$?

    if [[ $ret -eq 0 ]]; then
    
        while read -r file; do
        [ -f "$file" ] && cp -f "$file" \
        "$DM_tlt/files/$(basename "$file" |iconv -c -f utf8 -t ascii)"
        done <<<"$(tr '|' '\n' <<<"$FL")"
    fi
    
} >/dev/null

videourl() {

    n=$(ls *.url "$DM_tlt/files/" | wc -l)
    url=$(yad --form --title=" " \
    --name=Idiomind --class=Idiomind \
    --separator="" \
    --window-icon="$DS/images/icon.png" \
    --skip-taskbar --center --on-top \
    --width=420 --height=100 --borders=5 \
    --field="$(gettext "URL")" \
    --button="$(gettext "Cancel")":1 \
    --button=gtk-ok:0)
    [[ $? = 1 ]] && exit
    if [ ${#url} -gt 40 ] && \
    ([ ${url:0:29} = 'https://www.youtube.com/watch' ] \
    || [ ${url:0:28} = 'http://www.youtube.com/watch' ]); then \
    echo "$url" > "$DM_tlt/files/video$n.url"
    else msg "$(gettext "Invalid URL.")\n" error \
    "$(gettext "Invalid URL")"; fi
}

attatchments() {

    mkindex() {

rename 's/_/ /g' "$DM_tlt/files"/*
echo "<meta http-equiv=\"Content-Type\" \
content=\"text/html; charset=UTF-8\" />
<link rel=\"stylesheet\" \
href=\"/usr/share/idiomind/default/attch.css\">\
<body>" > "$DC_tlt/att.html"

while read -r file; do
if grep ".mp3" <<<"${file: -4}"; then
echo "${file::-4}<br><br><audio controls>
<source src=\"../files/$file\" type=\"audio/mpeg\">
</audio><br><br>" >> "$DC_tlt/att.html"
elif grep ".ogg" <<<"${file: -4}"; then
echo "${file::-4}<audio controls>
<source src=\"../files/$file\" type=\"audio/mpeg\">
</audio><br><br>" >> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

while read -r file; do
if grep ".txt" <<<"${file: -4}"; then
txto=$(sed ':a;N;$!ba;s/\n/<br>/g' \
< "$DM_tlt/files/$file" \
| sed 's/\"/\&quot;/;s/\&/&amp;/g')
echo "<div class=\"summary\">
<h2>${file::-4}</h2><br>$txto \
<br><br><br></div>" >> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

while read -r file; do
if grep ".mp4" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<video width=450 height=280 controls>
<source src=\"../files/$file\" type=\"video/mp4\">
</video><br><br><br>" >> "$DC_tlt/att.html"
elif grep ".m4v" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<video width=450 height=280 controls>
<source src=\"../files/$file\" type=\"video/mp4\">
</video><br><br><br>" >> "$DC_tlt/att.html"
elif grep ".jpg" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".jpeg" <<<"${file: -5}"; then
echo "${file::-5}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".png" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"
elif grep ".url" <<<"${file: -4}"; then
url=$(tr -d '=' < "$DM_tlt/files/$file" \
| sed 's|watch?v|v\/|;s|https|http|g')
echo "<iframe width=\"100%\" height=\"85%\" src=\"$url\" \
frameborder=\"0\" allowfullscreen></iframe>
<br><br>" >> "$DC_tlt/att.html"
elif grep ".gif" <<<"${file: -4}"; then
echo "${file::-4}<br><br>
<img src=\"../files/$file\" alt=\"$name\" \
style=\"width:100%;height:100%\"><br><br><br>" \
>> "$DC_tlt/att.html"; fi
done <<<"$(ls "$DM_tlt/files")"

echo "</body>" >> "$DC_tlt/att.html"
    
    } >/dev/null 2>&1
    
    [ ! -d "$DM_tlt/files" ] && mkdir "$DM_tlt/files"
    ch1="$(ls -A "$DM_tlt/files")"
    
    if [[ "$(ls -A "$DM_tlt/files")" ]]; then
        [ ! -f "$DC_tlt/att.html" ] && mkindex >/dev/null 2>&1
        yad --html --title="$(gettext "Attached Files")" \
        --name=Idiomind --class=Idiomind \
        --uri="$DC_tlt/att.html" --browser \
        --window-icon="$DS/images/icon.png" --center \
        --width=680 --height=580 --borders=10 \
        --button="$(gettext "Folder")":"xdg-open \"$DM_tlt\"/files" \
        --button="$(gettext "Video URL")":2 \
        --button="gtk-add":0 \
        --button="gtk-close":1
        ret=$?
        
        if [[ $ret = 0 ]]; then "$DS/ifs/tls.sh" add_file
        elif [[ $ret = 2 ]]; then "$DS/ifs/tls.sh" videourl; fi
        
        if [[ "$ch1" != "$(ls -A "$DM_tlt/files")" ]]; then
        mkindex; fi
        
    else
        yad --form --title="$(gettext "Attached Files")" \
        --text="  $(gettext "Save files related to topic")" \
        --name=Idiomind --class=Idiomind \
        --window-icon="$DS/images/icon.png" --center \
        --width=350 --height=180 --borders=5 \
        --field="$(gettext "Add File")":FBTN "$DS/ifs/tls.sh 'add_file'" \
        --field="$(gettext "YouTube Video URL")":FBTN "$DS/ifs/tls.sh 'videourl'" \
        --button="$(gettext "Cancel")":1 \
        --button="$(gettext "OK")":0
        ret=$?
        
        if [[ "$ch1" != "$(ls -A "$DM_tlt/files")" ]] && [[ $ret = 0 ]]; then
            mkindex
        fi
    fi
} >/dev/null 2>&1

help() {

    URL="http://idiomind.sourceforge.net/doc/$(gettext "help").pdf"
    xdg-open "$URL"
     
} >/dev/null 2>&1

definition() {

    URL="http://glosbe.com/$lgt/$lgs/${2,,}"
    xdg-open "$URL"
}

web() {

    web="http://idiomind.sourceforge.net"
    xdg-open "$web/$lgs/${lgtl,,}" >/dev/null 2>&1
}

fback() {
    
    internet
    URL="http://idiomind.sourceforge.net/doc/msg.html"
    yad --html --title="$(gettext "Feedback")" \
    --name=Idiomind --class=Idiomind \
    --browser --uri="$URL" \
    --window-icon="$DS/images/icon.png" \
    --no-buttons --fixed \
    --width=500 --height=450
     
} >/dev/null 2>&1

colorize() {

    > "$DT/ps_lk"
    rm "${DC_tlt}/5.cfg"
    cfg5="${DC_tlt}/5.cfg"
    cfg6="$(< "${DC_tlt}/6.cfg")"
    img1='/usr/share/idiomind/images/1.png'
    img2='/usr/share/idiomind/images/2.png'
    img3='/usr/share/idiomind/images/3.png'
    img0='/usr/share/idiomind/images/0.png'
    log3="$(< "${DC_tlt}/practice/log.3")"
    log2="$(< "${DC_tlt}/practice/log.2")"
    log1="$(< "${DC_tlt}/practice/log.1")"
    
    while read -r item; do
    
        if grep -Fxo "${item}" <<<"${cfg6}"; then
        i="<b><big>${item}</big></b>";else i="${item}"; fi
        if grep -Fxo "${item}" <<<"${log3}"; then
            echo -e "FALSE\n${i}\n$img3" >> "$cfg5"
        elif grep -Fxo "${item}" <<<"${log1}"; then
            echo -e "FALSE\n${i}\n$img1" >> "$cfg5"
        elif grep -Fxo "${item}" <<<"${log2}"; then
            echo -e "FALSE\n${i}\n$img2" >> "$cfg5"
        else
            echo -e "FALSE\n${i}\n$img0" >> "$cfg5"
        fi
    done < "${DC_tlt}/1.cfg"
    rm -f "$DT/ps_lk"; cd ~/
}


check_updates() {

    internet
    nver=`curl http://idiomind.sourceforge.net/doc/release |sed -n 1p`
    cver=`echo "$(idiomind -v)"`
    pkg='https://sourceforge.net/projects/idiomind/files/idiomind.deb/download'
    echo "$(date +%d)" > "$DC_s/9.cfg"
    if [ ${#nver} -lt 9 ] && [ ${#cver} -lt 9 ] \
    && [ ${#nver} -ge 3 ] && [ ${#cver} -ge 3 ] \
    && [ "$nver" != "$cver" ]; then
    
        msg_2 " <b>$(gettext "A new version of Idiomind available\!")</b>\n" \
        info "$(gettext "Download")" "$(gettext "Cancel")" $(gettext "Idiomind - New Version")
        ret=$(echo $?)
        
        if [[ $ret -eq 0 ]]; then xdg-open "$pkg"; fi
        
    else
        msg " $(gettext "No updates available.")\n" info $(gettext "Updates")
    fi

    exit 0
}

a_check_updates() {

    [[ ! -f "$DC_s/9.cfg" ]] && echo `date +%d` > "$DC_s/9.cfg" && exit
    d1=$(< "$DC_s/9.cfg"); d2=$(date +%d)
    if [[ "$(sed -n 1p "$DC_s/9.cfg")" = 28 ]] && \
    [[ "$(wc -l < "$DC_s/9.cfg")" -gt 1 ]]; then
    rm -f "$DC_s/9.cfg"; fi
    [[ "$(wc -l < "$DC_s/9.cfg")" -gt 1 ]] && exit 1

    if [[ "$d1" != "$d2" ]]; then

        curl -v www.google.com 2>&1 | \
        grep -m1 "HTTP/1.1" >/dev/null 2>&1 || exit 1
        echo "$d2" > "$DC_s/9.cfg"
        nver=`curl http://idiomind.sourceforge.net/doc/release | sed -n 1p`
        cver=`echo "$(idiomind -v)"`
        pkg='https://sourceforge.net/projects/idiomind/files/idiomind.deb/download'
        if [ ${#nver} -lt 9 ] && [ ${#cver} -lt 9 ] \
        && [ ${#nver} -ge 3 ] && [ ${#cver} -ge 3 ] \
        && [ "$nver" != "$cver" ]; then
            
            msg_2 " <b>$(gettext "A new version of Idiomind available\!")\n</b>\n $(gettext "Do you want to download it now?")\n" info "$(gettext "Download")" "$(gettext "Cancel")" "$(gettext "Idiomind - New Version")" "$(gettext "Ignore")"
            ret=$?
            
            if [[ $ret -eq 0 ]]; then xdg-open "$pkg"
            
            elif [[ $ret -eq 2 ]]; then echo "$d2" >> "$DC_s/9.cfg"; fi
        fi
    fi
    exit 0
}

about() {

#about.set_website(app_website)
#about.set_website_label(web)
c="$(gettext "Vocabulary learning tool")"
website="$(gettext "Web Site")"
export c website
python << ABOUT
import gtk
import os
app_logo = os.path.join('/usr/share/idiomind/images/idiomind.png')
app_icon = os.path.join('/usr/share/idiomind/images/icon.png')
app_name = 'Idiomind'
app_version = 'v2.2-beta'
app_comments = os.environ['c']
web = os.environ['website']
app_copyright = 'Copyright (c) 2015 Robin Palatnik'
app_website = 'http://idiomind.sourceforge.net/'
app_license = (('This program is free software: you can redistribute it and/or modify\n'+
'it under the terms of the GNU General Public License as published by\n'+
'the Free Software Foundation, either version 3 of the License, or\n'+
'(at your option) any later version.\n'+
'\n'+
'This program is distributed in the hope that it will be useful,\n'+
'but WITHOUT ANY WARRANTY; without even the implied warranty of\n'+
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n'+
'GNU General Public License for more details.\n'+
'\n'+
'You should have received a copy of the GNU General Public License\n'+
'along with this program.  If not, see <http://www.gnu.org/licenses/>.'))
app_authors = ['Robin Palatnik <patapatass@hotmail.com>']
app_artists = [' ']

class AboutDialog:
    def __init__(self):
        about = gtk.AboutDialog()
        about.set_logo(gtk.gdk.pixbuf_new_from_file(app_logo))
        about.set_icon_from_file(app_icon)
        about.set_wmclass('Idiomind', 'Idiomind')
        about.set_name(app_name)
        about.set_program_name(app_name)
        about.set_version(app_version)
        about.set_comments(app_comments)
        about.set_copyright(app_copyright)
        about.set_license(app_license)
        about.set_authors(app_authors)
        about.set_artists(app_artists)
        about.run()
        about.destroy()

if __name__ == "__main__":
    AboutDialog = AboutDialog()
    main()
ABOUT
} >/dev/null 2>&1

set_image() {

    cd "$DT"
    source "$DS/ifs/mods/add/add.sh"
    file=`get_name_file "${2}" "${3}"`
    ifile="${DM_tlt}/images/$file.jpg"

    if [ -f "$ifile" ]; then
    
        image="--image=$ifile"
        btn2="--button="$(gettext "Delete")":2"
        dlg_form_3
        ret=$?
        
        if [[ $ret -eq 2 ]]; then rm -f "$ifile"; fi
        
    else 
        scrot -s --quality 90 "$file.temp.jpeg"
        /usr/bin/convert "$file.temp.jpeg" -interlace Plane -thumbnail 100x90^ \
        -gravity center -extent 100x90 -quality 90% "$file"_temp.jpeg
        /usr/bin/convert "$file.temp.jpeg" -interlace Plane -thumbnail 405x275^ \
        -gravity center -extent 400x270 -quality 90% "$ifile"
        "$DS/ifs/tls.sh" set_image "${2}" "${3}" & exit

    fi

    rm -f "$DT"/*.jpeg
    exit
    
} >/dev/null 2>&1

mkpdf() {

    cd "$HOME"
    pdf=$(yad --file --save --title="$(gettext "Export to PDF")" \
    --name=Idiomind --class=Idiomind \
    --filename="$HOME/$tpc.pdf" \
    --window-icon="$DS/images/icon.png" --center --on-top \
    --width=600 --height=500 --borders=5 \
    --button="$(gettext "Cancel")":1 \
    --button="$(gettext "OK")":0)
    ret=$?

    if [[ $ret -eq 0 ]]; then
    
        [ -d "$DT/mkhtml" ] && rm -fr "$DT/mkhtml"
        mkdir -p "$DT/mkhtml/images"; wdir="$DT/mkhtml"
        cfg0="${DC_tlt}/0.cfg"
        cfg3="${DC_tlt}/3.cfg"
        cfg4="${DC_tlt}/4.cfg"
        nts="$(sed ':a;N;$!ba;s/\n/<br>/g' < "${DC_tlt}/info" \
        | sed 's/\&/&amp;/g')"
        if [ -f "${DM_tlt}/images/img.jpg" ]; then
        convert "${DM_tlt}/images/img.jpg" \
        -alpha set -channel A -evaluate set 50% "$wdir/img.png"; fi
        
        while read -r word; do

            item="$(grep -F -m 1 "trgt={${word}}" "${cfg0}" |sed 's/},/}\n/g')"
            fname="$(grep -oP '(?<=id=\[).*(?=\])' <<<"${item}")"

            if [ -f "${DM_tlt}/images/$fname.jpg" ]; then
            trgt="$(grep -oP '(?<=trgt={).*(?=})' <<<"${item}")"
            convert "${DM_tlt}/images/$fname.jpg" -alpha set -virtual-pixel transparent \
            -channel A -blur 0x10 -level 50%,100% +channel "$wdir/images/$trgt.png"
            echo "${trgt}" >> "$wdir/image_list"
            fi

        done < <(tac "${cfg3}")

        while read -r sntcs; do
        
            item="$(grep -F -m 1 "trgt={${sntcs}}" "${cfg0}" |sed 's/},/}\n/g')"
            trgt="$(grep -oP '(?<=trgt={).*(?=})' <<<"${item}")"
            srce="$(grep -oP '(?<=srce={).*(?=})' <<<"${item}")"
            if [ -n "${trgt}" ] && [ -n "${srce}" ]; then
            echo "${trgt}" >> "$wdir/trgt_sentences"
            echo "${srce}" >> "$wdir/srce_sentences"
            fi

        done < <(tac "${cfg4}")
        
        echo -e "<head>
        <meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
        <title>$tpc</title><head>
        <link rel=\"stylesheet\" href=\"/usr/share/idiomind/default/pdf.css\">
        </head>
        <body>
        <div><p></p>
        </div>
        <div>" >> "$wdir/doc.html"
        if [ -f "$wdir/img.png" ]; then
        echo -e "<table width=\"100%\" border=\"0\">
        <tr>
        <td><img src=\"$wdir/img.png\" alt="" border=0 height=100% width=100%></img>
        </td>
        </tr>
        </table>" >> "$wdir/doc.html"; fi
        echo -e "<p>&nbsp;</p>
        <h3>$tpc</h3>
        <hr>
        <div width=\"80%\" align=\"left\" border=\"0\" class=\"ifont\">
        <br>" >> "$wdir/doc.html"
        printf "$nts" >> "$wdir/doc.html"
        echo -e "<p>&nbsp;</p>
        <div>" >> "$wdir/doc.html"

        cd "${DM_tlt}/images"
        cnt=`ls -1 *.jpg | grep -v "img.jpg" | wc -l`
        if [[ $cnt -gt 0 ]]; then

            cd "$wdir"
            echo -e "<p>&nbsp;</p><table width=\"100%\" align=\"center\" border=\"0\" class=\"images\">" >> "$wdir/doc.html"
            n=1
            while [[ $n -lt $(($(wc -l < "$wdir/image_list")+1)) ]]; do
            
                    label1=$(sed -n ${n},$((n+1))p < "$wdir/image_list" |sed -n 1p)
                    label2=$(sed -n ${n},$((n+1))p < "$wdir/image_list" |sed -n 2p)
                    if [ -n "${label1}" ]; then
                        echo -e "<tr>
                        <td align=\"center\"><img src=\"images/$label1.png\" width=\"200\" height=\"140\"></td>" >> "$wdir/doc.html"
                        if [ -n "${label2}" ]; then
                        echo -e "<td align=\"center\"><img src=\"images/$label2.png\" width=\"200\" height=\"140\"></td></tr>" >> "$wdir/doc.html"
                        else
                        echo '</tr>' >> "$wdir/doc.html"
                        fi
                        echo -e "<tr>
                        <td align=\"center\" valign=\"top\"><p>${label1}</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p></td>" >> "$wdir/doc.html"
                        if [ -n "${label2}" ]; then
                        echo -e "<td align=\"center\" valign=\"top\"><p>${label2}</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p>
                        <p>&nbsp;</p></td>
                        </tr>" >> "$wdir/doc.html"
                        else
                        echo '</tr>' >> "$wdir/doc.html"
                        fi
                    else
                        break
                    fi

                ((n=n+2))
            done
            echo -e "</table>" >> "$wdir/doc.html"
        fi

        cd "$wdir"
        
        while read -r word; do
        
            item="$(grep -F -m 1 "trgt={${word}}" "${cfg0}" |sed 's/},/}\n/g')"
            trgt="$(grep -oP '(?<=trgt={).*(?=})' <<<"${item}")"
            srce="$(grep -oP '(?<=srce={).*(?=})' <<<"${item}")"
            exmp="$(grep -oP '(?<=exmp={).*(?=})' <<<"${item}")"
            defn="$(grep -oP '(?<=defn={).*(?=})' <<<"${item}")"
            ntes="$(grep -oP '(?<=note={).*(?=})' <<<"${item}")"
            fname="$(grep -oP '(?<=id=\[).*(?=\])' <<<"${item}")"
            hlgt="${trgt,,}"
            exmp1=$(echo "${exmp}" |sed "s/"$hlgt"/<b>"$hlgt"<\/\b>/g")
            
            if [ -n "${trgt}" ] && [ -n "${srce}" ]; then
            
                echo -e "<table width=\"55%\" border=\"0\" align=\"left\" cellpadding=\"10\" cellspacing=\"5\">
                <tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><w1>${trgt}</w1></td>
                </tr><tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><w2>${srce}</w2></td>
                </tr>
                </table>" >> "$wdir/doc.html"
                echo -e "<table width=\"100%\" border=\"0\" align=\"center\" cellpadding=\"10\" class=\"efont\">
                <tr>
                <td width=\"10px\"></td>" >> "$wdir/doc.html"
                if [ -z "${dftn}" ] && [ -z "${exmp1}" ]; then
                echo -e "<td width=\"466\" valign=\"top\" class=\"nfont\" >${ntes}</td>
                <td width=\"389\"</td>
                </tr>
                </table>" >> "$wdir/doc.html"
                else
                    echo -e "<td width=\"466\">" >> "$wdir/doc.html"
                    if [ -n "${dftn}" ]; then
                    echo -e "<dl>
                    <dd><dfn>${dftn}</dfn></dd>
                    </dl>" >> "$wdir/doc.html"
                    fi
                    if [ -n "${exmp1}" ]; then
                    echo -e "<dl>
                    <dt> </dt>
                    <dd><cite>${exmp1}</cite></dd>
                    </dl>" >> "$wdir/doc.html"
                    fi 
                    echo -e "</td>
                    <td width=\"400\" valign=\"top\" class=\"nfont\">${ntes}</td>
                    </tr>
                    </table>" >> "$wdir/doc.html"
                fi
            fi
            
        done < <(tac "${cfg3}")

        n=1; trgt=""
        while [[ $n -le "$(wc -l < "${cfg4}")" ]]; do
        
            trgt=$(sed -n ${n}p "$wdir/trgt_sentences")
            while read -r mrk; do
                if grep -Fxo ${mrk^} < "${cfg3}"; then
                trgsm=$(sed "s|$mrk|<mark>$mrk<\/mark>|g" <<<"$trgt")
                trgt="$trgsm"; fi
            done <<<"$(tr ' ' '\n' <<<"${trgt}")"

            if [ -n "${trgt}" ]; then
                srce=$(sed -n ${n}p "$wdir/srce_sentences")
                echo -e "<h1>&nbsp;</h1>
                <table width=\"100%\" border=\"0\" align=\"left\" cellpadding=\"10\" cellspacing=\"5\">
                <tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><h1>${trgt}</h1></td>
                </tr><tr>
                <td bgcolor=\"#E6E6E6\" class=\"side\"></td>
                <td bgcolor=\"#FFFFFF\"><h2>${srce}</h2></td>
                </tr>
                </table>
                <h1>&nbsp;</h1>" >> "$wdir/doc.html"
            fi
            let n++
        done

        echo -e "<p>&nbsp;</p>
        <p>&nbsp;</p>
        <h3>&nbsp;</h3>
        <p>&nbsp;</p>
        </div>
        </div>
        <span class=\"container\"></span>
        </body>
        </html>" >> "$wdir/doc.html"

        wkhtmltopdf -s A4 -O Portrait "$wdir/doc.html" "$wdir/tmp.pdf"
        mv -f "$wdir/tmp.pdf" "$pdf"
        rm -fr "$wdir"
    fi
    exit
}


if [ "$1" = play ]; then

    play "$2"
    
elif [ "$1" = listen_sntnc ]; then

    play "$DM_tlt/$2.mp3" >/dev/null 2>&1
    exit

elif [ "$1" = dclik ]; then

    play "$DM_tls/${2,,}.mp3" >/dev/null 2>&1
    exit

elif [ "$1" = play_temp ]; then

    nmt=$(sed -n 1p "/tmp/.idiomind-$USER/dir$2/folder")
    dir="/tmp/.idiomind-$USER/dir$2/$nmt"
    play "$dir/audio/${3,,}.mp3"
    exit
fi

gtext() {
$(gettext "Marked items")
$(gettext "Difficult words")
}>/dev/null 2>&1

case "$1" in
    details)
    details "$@" ;;
    check_index)
    check_index "$@" ;;
    add_audio)
    add_audio "$@" ;;
    edit_audio)
    edit_audio "$@" ;;
    text)
    text "$@" ;;
    adv)
    editadv "$@" ;;
    attachs)
    attatchments "$@" ;;
    add_file)
    add_file ;;
    videourl)
    videourl "$@" ;;
    help)
    help ;;
    colorize)
    colorize "$@" ;;
    definition)
    definition "$@" ;;
    check_updates)
    check_updates ;;
    a_check_updates)
    a_check_updates ;;
    set_image)
    set_image "$@" ;;
    pdf)
    mkpdf ;;
    conv)
    converti ;;
    html)
    mkhtml ;;
    sanity_1)
    sanity_1 "$@" ;;
    fback)
    fback ;;
    about)
    about ;;
esac
