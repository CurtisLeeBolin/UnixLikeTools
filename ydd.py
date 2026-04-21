#!/usr/bin/env -S /bin/sh -c '"$HOME/.local/lib/yt-dlp/bin/python" "$0" "$@"'


import yt_dlp
import os
import subprocess
import argparse
import glob


def get_outtmpl(url):
  if 'twitch.tv/' in url and '/clip/' in url:
    return '%(upload_date)s %(creator)s - %(title)s [%(id)s].%(ext)s'
  if 'twitch.tv/' in url:
    return '%(upload_date)s %(uploader_id)s - %(title)s [%(id)s].%(ext)s'
  return '%(upload_date)s %(uploader)s - %(title)s [%(id)s].%(ext)s'


def manual_mux(base_path, title):
  files = glob.glob(glob.escape(base_path) + "*")
  input_files = [f for f in files if not f.endswith('.mkv') and not f.endswith('.description')]
  
  if not input_files:
    return

  desc_path = f"{base_path}.description"
  description_text = ""
  if os.path.exists(desc_path):
    with open(desc_path, 'r', encoding='utf-8') as f:
      description_text = f.read().strip()

  use_bsf = False
  for f in input_files:
    probe = subprocess.run(
      ['ffprobe', '-v', 'error', '-select_streams', 'a', '-show_entries', 
       'stream=codec_name', '-of', 'csv=p=0', f],
      capture_output=True, text=True
    )
    if 'aac' in probe.stdout.lower():
      use_bsf = True
      break

  output_mkv = f"{base_path}.mkv"
  
  cmd = ['ffmpeg', '-y']
  for f in input_files:
    cmd += ['-i', f]
  
  for i in range(len(input_files)):
    cmd += ['-map', f'{i}:v?', '-map', f'{i}:a?', '-map', f'{i}:s?']
    
  cmd += ['-c', 'copy', '-ignore_unknown', '-map_metadata', '0']
  
  cmd += ['-metadata', f'title={title}']
  if description_text:
    cmd += ['-metadata', f'description={description_text}']

  if use_bsf:
    cmd += ['-bsf:a', 'aac_adtstoasc']

  cmd.append(output_mkv)

  if subprocess.run(cmd).returncode == 0:
    for f in input_files:
      if os.path.exists(f): os.remove(f)
    if os.path.exists(desc_path): os.remove(desc_path)


def download(urls, limit_1080p, live_from_start, chapters):
  ydl_opts = {
    'format': 'bv[height<=1080]+ba/b[height<=1080]' if limit_1080p else 'bestvideo+bestaudio/best',
    'merge_output_format': None,
    'fixup': 'never',
    'writesubtitles': True,
    'subtitleslangs': ['en', 'id', '-rechat', '-live_chat'], 
    'ignoreerrors': True,
    'writedescription': True,
    'writechapters': chapters,
    'live_from_start': live_from_start,
    'cookiefile': 'cookies.txt' if os.path.exists('cookies.txt') else None,
  }

  for url in urls:
    opts = ydl_opts.copy()
    opts['outtmpl'] = {'default': get_outtmpl(url)}
    
    with yt_dlp.YoutubeDL(opts) as ydl:
      info = ydl.extract_info(url, download=True)
      
      if 'entries' in info:
        entry = info['entries'][0]
      else:
        entry = info

      title = entry.get('title', 'Video')
      dest = entry.get('requested_downloads', [{}])[0].get('filepath') or entry.get('_filename')
      
      base_path = os.path.splitext(dest)[0]
      if '.f' in base_path:
        base_path = base_path.rsplit('.f', 1)[0]
    
    manual_mux(base_path, title)


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument('urls', nargs='+')
  parser.add_argument('--1080p', action='store_true', dest='limit_1080p')
  parser.add_argument('--from-start', action='store_true')
  parser.add_argument('--chapters', action='store_true')
  args = parser.parse_args()
  download(args.urls, args.limit_1080p, args.from_start, args.chapters)

