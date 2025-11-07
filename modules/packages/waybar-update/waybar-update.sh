#!/usr/bin/env bash

current=$(readlink -f /run/current-system)
latest=$(readlink -f /nix/var/nix/profiles/system)

if [[ "$latest" != "$current" ]]; then
  echo "{\"text\": \"󱑞\", \"tooltip\": \"New generation available\"}"
else
  echo
fi
