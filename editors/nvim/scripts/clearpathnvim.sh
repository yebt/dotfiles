#!/usr/bin/env bash

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # do dangerous stuff
  cdirs=(\
    ~/.cache/nvim \
    ~/.local/share/nvim \
    ~/.local/state/nvim \
  )

  for i in "${cdirs[@]}"
  do
    rm -rf $i
    echo "cleard: $i"
  done
  echo "OK ..."
else
  echo "Aborted"
fi
