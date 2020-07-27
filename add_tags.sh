#!/bin/bash

#-filter:a 'dynaudnorm=m=100.0:g=181:f=500:p=1.0' \

mkdir "tagged" 2>/dev/null
for filename in "${@}"; do
    artist=$(awk -F ' - ' '{print $1}' <<<${filename})
    album=$(awk -F ' - ' '{print $2}' <<<${filename})
    track=$(awk -F ' - ' '{print $3}' <<<${filename})
    num_tracks=$#
    title=$(awk -F ' - ' '{printf $4; for(i=5; i<=NF; ++i) printf " - %s", $i}' <<<${filename%.*})
    tempfile="tagged/${filename%.*}.ogg"
    
    echo "Filename:  ${filename}"
    echo "> Artist:  ${artist}"
    echo "> Album:   ${album}"
    echo "> Track:   ${track}/${num_tracks}"
    echo "> Title:   ${title}"
    echo

    ffmpeg -i "${filename}" \
    -map_metadata -1 \
    -metadata "title=${title}" \
    -metadata "artist=${artist}" \
    -metadata "album=${album}" \
    -metadata "track=${track}/${num_tracks}" \
    -c:a copy -map 0:a:0 \
    "${tempfile}"
done

