#!/bin/bash

for i in ~/.dotfiles/files/*; do
  echo "Installing $(basename $i)..."
  rm -rf ~/.$(basename $i)
  ln -s $i ~/.$(basename $i)
done
