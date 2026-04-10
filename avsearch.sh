#!/usr/bin/env bash

file_type_array=(avi flv mov mp4 mpeg mpg ogg ogm ogv wmv m2ts mkv rmvb rm 3gp m4a 3g2 mj2 asf divx vob webm)


path_to_search=$(realpath ${HOME}/{Videos,staging/{deinterlace,fab,i2psnark,process}}/)


print_help () {
  echo "avsearch - search for directories and files, giving info about video files"
  echo
  echo "avsearch [OPTION] [blob search term]"
  echo
  echo "'-h, --help' Prints this help."
  echo "'-v, --verbose' Extra info about video files"
}


get_regex_string () {
  init_run=true
  for ext in "${file_type_array[@]}"; do
    if ${init_run}; then
      ext_regex_string="(${ext}"
    else
      ext_regex_string="${ext_regex_string}|${ext}"
    fi
    init_run=false
  done
  ext_regex_string="${ext_regex_string})"
  #regex_string=".*$(printf '%q' ${query}).*${ext_regex_string}"
  regex_string=".*${query}.*${ext_regex_string}"
}


search () {
  #find ${path_to_search} -type f -regextype posix-egrep -iregex "${regex_string}" -printf '%f\n' | sort
  find ${path_to_search} -type f -regextype posix-egrep -iregex "${regex_string}" | sort
}


search_verbose () {
  result_array=()
  mapfile -d '' result_array < <(find ${path_to_search} -type f -regextype posix-egrep -iregex "${regex_string}" -print0 2>/dev/null)
  for result in "${result_array[@]}"; do
    echo "${result}"
    file_data_array=($(ls -lh --full-time "${result}"))
    echo "${file_data_array[4]} ${file_data_array[5]} ${file_data_array[6]%.*}"
    ffprobe "${result}" 2>&1 | grep "Stream #0:.*:\|Duration:*" | sed 's/^[ ][ ]//'
    echo -e '\n'
  done
}


error_message () {
  echo "Not Enough Arguments Given!"
  echo
  print_help
  exit 1
}


if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  print_help
  exit 0
elif [ "${1}" == "-v" ] || [ "${1}" == "--verbose" ]; then
  if [ -n "${1}" ]; then
    shift
    query="${@}"
    regex_string=
    get_regex_string
    search_verbose
  else
    error_message
  fi
else
  if [ -n "${1}" ] || [ -n "${2}" ]; then
    query="${@}"
    regex_string=
    get_regex_string
    search
  else
    error_message
  fi
fi
