#!/usr/bin/env bash

FORCED_TRACKS=2
IN_DIR="0in"
OUT_DIR="0out"

mkdir "${IN_DIR}" "${OUT_DIR}"

for each in "$@"; do

  fileName="${each}"
  titleName="${each%.*}"

  mv "${fileName}" "${IN_DIR}"/"${fileName}"

  mkvmerge --title "${titleName}" -o "${OUT_DIR}"/"${titleName}".mkv --forced-track "${FORCED_TRACKS}" "${IN_DIR}"/"${titleName}".mkv

done
