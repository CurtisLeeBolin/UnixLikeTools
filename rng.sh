#!/usr/bin/env bash

echo $(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 13)



