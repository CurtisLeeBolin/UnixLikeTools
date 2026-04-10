#!/usr/bin/env bash
# update-ofscraper.sh

app='ofscraper'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

pyenv install 3.12.13 --skip-existing
cp -a ~/.pyenv/versions/3.12.13 ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

#~/.local/lib/"${app}"/bin/python -m pip install git+https://github.com/datawhores/OF-Scraper.git
~/.local/lib/"${app}"/bin/python -m pip install "${app}"

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
