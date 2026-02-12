#!/usr/bin/env bash

curl -fsSL https://launchermeta.mojang.com/mc/game/version_manifest.json \
  | jq -rn 'first( inputs | .versions[] | select(.type == "release") )' \
  | jq -r '.url' \
  | xargs curl -fsSL \
  | jq -r '.downloads.server.url' \
  | xargs curl -fsSL -o minecraft_server.jar
