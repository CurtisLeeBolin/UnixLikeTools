#!/usr/bin/env bash

print_help () {
  echo "avfilerename - renames files with an incrementing number"
  echo
  echo "avfilerename [OPTION] [FILE PREFIX] [START NUMBER] [FILE POSTFIX]"
  echo
  echo "'-h, --help' Prints this help."
  echo "'-n n' Sets the number of digits. The default is 2."
}

d=2
if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  print_help
  exit 0
fi
if [ "${1}" == "-n" ]; then
  shift
  d="${1}"
  shift
fi

if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ]; then
  echo "Not Enough Arguments Given!"
  echo
  print_help
  exit 1
fi

i=${2}
for f in *; do
	if [ -f "${f}" ]; then
		mv -i -- "${f}" "$(printf "%s%0${d}d%s" "${1}" "${i}" "${3}")"
		let i=i+1
	fi
done
