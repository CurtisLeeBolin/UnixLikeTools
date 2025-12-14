#!/bin/bash
# update-gallery-dl.sh

app='gallery-dl'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

#~/.local/lib/"${app}"/bin/python -m pip install git+https://github.com/mikf/"${app}".git
~/.local/lib/"${app}"/bin/python -m pip install "${app}[extra]"
~/.local/lib/"${app}"/bin/python -m pip install "yt-dlp[default,curl-cffi]"

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
