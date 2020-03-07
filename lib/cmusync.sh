#!/usr/bin/env sh
# A status display program for cmus (:set status_display_program)
# Writes the current line to ~/.config/cmus/cmusync.

LYRICS_FILE="${LYRICS_FILE:-$HOME/.config/cmus/cmusync}"

# Kill other instances of this script
pkill -f '^awk -v script_identifier=cmusync'

while [ "$1" != "" ]; do
    case "$1" in
        title)
            title="$2"
            ;;
        artist)
            artist="$2"
            ;;
        file)
            file="$2"
            ;;
        status)
            if [ "$2" != "playing"  ]; then
                exit
            fi
            ;;
        *)
            ;;
    esac
    shift
    shift
done

position="$(cmus-remote -Q | awk '$1 == "position" {print $2; exit}')"

awk -v script_identifier=cmusync -v title="$title" -v artist="$artist" -v position="$position" '
function parse_timestamp(line) {
    minutes = substr(line, 2, 2)
    seconds = substr(line, 5, 5)
    return seconds + minutes * 60
}

BEGIN {
    printf "Now playing: %s - %s\n", artist, title
}

{
    line_timing = parse_timestamp($0)
    if (line_timing < position) {
        next
    }
    system(sprintf("sleep %f", line_timing - position))
    line_text = substr($0, 11)
    sub("^ ", "", line_text)
    print line_text
    position = line_timing
}
' "${file%.*}.lrc" > "$LYRICS_FILE"
