#!/bin/sh

for i in $(dirname $(readlink -f $0))/files/*; do
	echo "Installing $(basename $i)..."
	rm -rf ~/.$(basename $i)
	ln -s $i ~/.$(basename $i)
done

echo "Done."
