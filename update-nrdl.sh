#!/usr/bin/env bash
# update-nrdl.sh

if [ ! -d ~/.local/lib/nrdl/ ]; then
  python -m venv ~/.local/lib/nrdl
fi

~/.local/lib/nrdl/bin/python -m pip install --upgrade pip

if [ -d ~/Projects/nrdl/ ]; then
  ~/.local/lib/nrdl/bin/python -m pip install ~/Projects/nrdl/
else
  ~/.local/lib/nrdl/bin/python -m pip install git+https://github.com/Jules-WinnfieldX/CyberDropDownloader
fi

#cp ~/.local/lib/nrdl/bin/cyberdrop-dl ~/.local/bin/nrdl
