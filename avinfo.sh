#!/usr/bin/env bash

file=${1}

ffprobe -i "${file}" 2>&1 | grep -P --color=always "DATE.*?:|Duration:*|Stream #0:.*?:"
