#!/bin/sh
''':'
exec "$HOME/.local/lib/gallery-dl/bin/python" "$(command -v "$0")" "$@"
'''

import sys
import os
import argparse
from datetime import datetime

# Import core elements safely
from gallery_dl import config, job

def setup_gallery_dl_config(args):
  '''Sets up configuration parameters exactly matching your bash flags.'''
  config.load()  # Loads any user configuration at ~/.config/gallery-dl/config.json

  # 1. Map global performance settings
  config.set((), 'sleep', (2.3, 15.7))
  config.set((), 'user-agent', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36')
  config.set((), 'base-directory', os.path.abspath('.'))
  config.set((), 'directory', '')

  # 2. Check for fallback cookies
  if os.path.exists('cookies.txt'):
    config.set((), 'cookies', 'cookies.txt')

  # 3. Dynamic Filter (Images flag vs Audio/Video strings)
  if args.images:
    config.set((), 'filter', None)
  else:
    config.set((), 'filter', 'extension in ("webm", "ogg", "mp4", "m4v", "mov")')

  # 4. Resume Cursor mapping
  if args.resume:
    config.set((), 'cursor', args.resume)

class CustomFilenameJob(job.DownloadJob):
  '''Intercepts and sanitizes the 'date' field into a proper native datetime object.'''

  def _sanitize_metadata(self, d):
    '''Forces the 'date' key to be a valid Python datetime object.'''
    raw_date = d.get('date')
    parsed_date = None

    if isinstance(raw_date, datetime):
      parsed_date = raw_date
    elif isinstance(raw_date, str):
      cleaned_str = raw_date.strip()
      if 'Invalid' in cleaned_str or not cleaned_str:
        parsed_date = datetime.now()
      else:
        # Intercept common site date layout strings (like Gofile space layouts)
        for fmt in ('%Y-%m-%d %H:%M:%S', '%Y-%m-%dT%H:%M:%S', '%Y-%m-%d'):
          try:
            parsed_date = datetime.strptime(cleaned_str, fmt)
            break
          except ValueError:
            continue
        if not parsed_date:
          try:
            parsed_date = datetime.fromisoformat(cleaned_str)
          except ValueError:
            parsed_date = datetime.now()
    else:
      # If the date is completely missing or None, default to right now
      parsed_date = datetime.now()

    # Overwrite the standard 'date' field with the real datetime object
    d['date'] = parsed_date

  def _recursive_patch(self, obj):
    '''Recursively steps through messages to patch dictionaries.'''
    if isinstance(obj, dict):
      self._sanitize_metadata(obj)
    elif isinstance(obj, (tuple, list)):
      for item in obj:
        self._recursive_patch(item)

  def dispatch(self, msg):
    # Scan and fix all metadata dictionary contexts flowing through the pipe
    self._recursive_patch(msg)

    if hasattr(self, 'extractor') and hasattr(self.extractor, 'keywords') and isinstance(self.extractor.keywords, dict):
      self._sanitize_metadata(self.extractor.keywords)

    if hasattr(self, 'keywords') and isinstance(self.keywords, dict):
      self._sanitize_metadata(self.keywords)

    super().dispatch(msg)

def main():
  parser = argparse.ArgumentParser(description='Python wrapper for gallery-dl')
  parser.add_argument('--images', action='store_true', help='Download images instead of video fields')
  parser.add_argument('--resume', type=str, metavar='CURSOR', help='Resume from explicit cursor token')
  parser.add_argument('urls', nargs='+', help='Target uniform resource locators')
  args = parser.parse_args()

  setup_gallery_dl_config(args)

  # Use your clean, original naming layout with the native token
  naming_schema = (
    '{date:%Y%m%d}'
    ' '
    '{author[name]|author|user[name]|user|username|fullname|uploader|Unknown}'
    ' - '
    '{content|text|title|caption|description|message|NoTitle:[b:150]}'
    ' '
    '[{media_id|tweet_id|id|image_id|filename}_{num}].{extension}'
  )
  config.set((), 'filename', naming_schema)

  # Run execution loop
  for url in args.urls:
    try:
      CustomFilenameJob(url).run()
    except Exception as e:
      print(f'Error processing target:\n{url}', file=sys.stderr)
      print(f'Exception:\n{e}', file=sys.stderr)

if __name__ == '__main__':
  main()
