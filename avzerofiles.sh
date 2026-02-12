#!/usr/bin/env bash
# Zero out all files in a directory

echo "Are you sure? [y/n] "

read confirm

if [ "$confirm" != "y" ]; then
	exit 0
fi

for file in *; do
	if [ -f "$file" ]; then
		rm "$file"
		touch "$file"
	fi
done
