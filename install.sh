#!/bin/sh

for i in $(pwd)/files/*; do
  echo "Installing $(basename $i)..."
  rm -rf ~/.$(basename $i)
  ln -s $i ~/.$(basename $i)
done

echo "Done."
