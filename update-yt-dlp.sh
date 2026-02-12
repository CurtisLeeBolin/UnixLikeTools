#!/usr/bin/env bash
# update-yt-dlp.sh

app='yt-dlp'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

#~/.local/lib/yt-dlp/bin/python -m pip install git+https://github.com/"${app}"/"${app}".git
~/.local/lib/"${app}"/bin/python -m pip install --force-reinstall "${app}[default,curl-cffi,secretstorage] @ https://github.com/yt-dlp/yt-dlp/archive/master.tar.gz"

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
