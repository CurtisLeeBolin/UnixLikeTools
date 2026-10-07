#!/usr/bin/env python


import os
import re
import subprocess
import time
import datetime
import pathlib


video_ext = (
  'mkv',
  'mp4',
  'm4v',
  'mov',
  'avi',
  'wmv',
  'webm',
  'ts'
)


def find_files_by_extension(directory_path, target_extension):
  found_files = []
  for root, _, files in os.walk(directory_path):
    for file in files:
      if not 'clips' in root:
        if file.lower().endswith(target_extension):
          full_path = os.path.join(root, file)
          found_files.append(full_path)
  return found_files


def runSubprocess(command):
  with subprocess.Popen(
    command, stderr=subprocess.PIPE, universal_newlines=True, errors='replace'
  ) as p:
    stderrList = ['']*256
    for line in p.stderr:
      del stderrList[0]
      stderrList.append(line)
    p.wait()
    return (p.returncode, stderrList)


def main():
  file_list = find_files_by_extension('./', video_ext)
  print(len(file_list))
  for file in file_list:
    command = [
      'ffprobe',
      '-hide_banner',
      file
    ]
    returncode, stderrList = runSubprocess(command)
    if returncode != 0:
      print(stderrList[-1])
      pathlib.Path(file).unlink(missing_ok=True)
    else:
      stderrData = ''.join(stderrList)
      duration = re.findall('Duration: (.*?),', stderrData)[-1]
      if not duration == 'N/A':
        x = time.strptime(duration.split('.')[0], '%H:%M:%S')
        s = int(datetime.timedelta(hours=x.tm_hour,minutes=x.tm_min,seconds=x.tm_sec).total_seconds())
        if s < 240:
          print(f'{s:3d}s  {file}')
          pathlib.Path(file).unlink(missing_ok=True)
      else:
        with open('./NA.log', 'a') as f:
          f.write(f'{file}\n')


if __name__ == '__main__':
  main()
