#!/bin/bash -e

umask 077
WORK_DIR="`mktemp -d /tmp/itms_m4a_clean.XXXXXXXX`"
trap "{ rm -rf $WORK_DIR; }" EXIT TERM INT

if sed --version 2>&1 | head -1 | grep ^GNU > /dev/null
then
        SED_FLAGS="$SED_FLAGS --regexp-extended"
else
        SED_FLAGS="$SED_FLAGS -E"
fi


POS=0

for SRC in "$@"
do
	
	POS="$(($POS + 1))"
	PIX_PREFIX="`printf 'pix%08x' $POS`"
	
	TEMP_MP4="$WORK_DIR/audio.mp4"
	OUTPUT_M4A="`echo "$SRC" | sed $SED_FLAGS 's/\.[^/.]+$//'`-clean.m4a"
	
	[ -f "$TEMP_MP4" ] && rm "$TEMP_MP4"
	
	ffmpeg -v -1 -y -i "$SRC" -vn -acodec copy "$TEMP_MP4" 2>&1 | \
		(egrep -v \
			-e '^FFmpeg version' \
			-e '^  lib[a-z]+ ' \
			-e '^ *(configuration:|lib[a-z]+ version:|built on )' \
			|| true) 1>&2
	
	CMD_FILE="$WORK_DIR/cmd.sh"
	(
		
		echo AtomicParsley \""$TEMP_MP4"\" --DeepScan -o \""$OUTPUT_M4A"\"
		
		AtomicParsley "$SRC" --extractPixToPath="$WORK_DIR/$PIX_PREFIX" -t | egrep '^Atom "[^"]+" contains: ' | while read X CODE Y VALUE
		do
			CODE="`echo "$CODE" | sed 's/"//g'`"
		
			case "$CODE" in
				"©nam")
					echo --title=\""$VALUE"\"
					;;
				"©ART")
					echo --artist=\""$VALUE"\"
					;;
				"aART")
					echo --albumArtist=\""$VALUE"\"
					;;
				"©wrt")
					echo --composer=\""$VALUE"\"
					;;
				"©alb")
					echo --album=\""$VALUE"\"
					;;
				"gnre")
					echo --genre=\""$VALUE"\"
					;;
				"trkn")
					echo --tracknum=\""`echo "$VALUE" | sed 's# of #/#'`"\"
					;;
				"disk")
					echo --disk=\""`echo "$VALUE" | sed 's# of #/#'`"\"
					;;
				"©day")
					echo --year=\""$VALUE"\"
					;;
				"cpil")
					echo --compilation=\""$VALUE"\"
					;;
				"pgap")
					echo --gapless=\""$VALUE"\"
					;;
				"rtng")
					echo --advisory=\""$VALUE"\"
					;;
				"stik")
					echo --stik=\""$VALUE"\"
					;;
				"©lyr")
					echo --lyrics=\""$VALUE"\"
					;;
				"©grp")
					echo --grouping=\""$VALUE"\"
					;;
				"©cmt")
					echo --comment=\""$VALUE"\"
					;;
				"sonm"|"soar"|"soaa"|"soal"|"soco"|"sosn")
					case "$CODE" in
						"sonm")
							SORT_TYPE="name"
							;;
						"soar")
							SORT_TYPE="artist"
							;;
						"soaa")
							SORT_TYPE="albumartist"
							;;
						"soal")
							SORT_TYPE="album"
							;;
						"soco")
							SORT_TYPE="composer"
							;;
						"sosn")
							SORT_TYPE="show"
							;;
						*)
							echo Unexpected sort field: "$CODE" >&2
							exit 1
							;;
					esac
					echo --sortOrder "$SORT_TYPE" \""$VALUE"\"
					;;
				apID|cprt|cnID|atID|cmID|plID|geID|sfID|akID|purd)
					# ignore these
					;;
				covr)
					# cover images are exported to files
					;;
				*)
					echo "Unknown metadata field $CODE: \"$VALUE\")" >&2
					;;
			esac
		
		done
	
		for PIC in "$WORK_DIR/${PIX_PREFIX}"*
		do
			echo --artwork=\""$PIC"\"
		done
		
		echo \> /dev/null
	
	) | tr '\n' ' ' > "$CMD_FILE"
	. "$CMD_FILE"
	
done
