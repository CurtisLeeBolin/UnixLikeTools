#!/usr/bin/env bash

INPUT_DIR=0in
OUTPUT_DIR=0out

transcode () {
	if [ "${4}" != "" ]; then
		args=(
			-i "${1}"
			-filter:v "${4}"
			-c:v libx264
			-profile:v high
			-c:a aac
			-q:a 3
			-sn
			-movflags faststart
			-map_metadata -1
			-metadata title="${3}"
			-y
			"${2}"
		)
	else
    args=(
      -i "${1}"
      -c:v libx264
      -profile:v high
      -c:a aac
      -q:a 3
      -sn
      -movflags faststart
			-map_metadata -1
      -metadata title="${3}"
      -y
      "${2}"
    )
	fi
	ffmpeg "${args[@]}"
}

transcode_dir () {
	mkdir "${1}"
	mkdir "${2}"

	for i in *.mkv *.webm; do
  	mv "${i}" "${1}"

		input="./${1}/${i}"
		output="./${2}/${i%.*}.mp4"
		title="${i%%.*}"
		filter_video="$3"

		transcode "${input}" "${output}" "${title}" "${filter_video}"
	done
}

filter_video=""

case $1 in
	-h|--help)
		echo "-h --help returns this help" \
				 "--deinterlace deinterlaces the video"
				 "--scale scales video to 720p"
		exit 0
		;;
	--deinterlace)
		filter_video="yadif=0:-1:0"
		;;
  --scale)
    filter_video="scale=800:-1"
		;;
esac

transcode_dir "${INPUT_DIR}" "${OUTPUT_DIR}" "${filter_video}"


#for i in *.mkv; do
#	mv "${i}" 0in/
#	ffmpeg -i 0in/"${i}" "${filter_video}" -c:v libx264 -profile:v high -c:a aac -q:a 3 -sn -movflags faststart -metadata title="${i%.mkv}" "${i%.mkv}".mp4
#done
