#!/usr/bin/env bash

mkdir 0in

for i in *.mkv; do
	mv "${i}" 0in/
	ffmpeg -i 0in/"${i}" -vn -c:a aac -sn "${i%.mkv}".m4a
done
