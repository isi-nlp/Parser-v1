#!/bin/bash

langs="de fr it es pt sv"
for ll in $langs; do
	echo "=================================================="
	echo "$ll"
	echo "=================================================="
	# cat data/$ll/test.lc.lid | cut -f 8 | grep -vP "^\s*$" | sort -b | \
	cat data/$ll/train.all.fix | cut -f 8 | grep -vP "^\s*$" | sort -b | \
	uniq -c | sort -nbr | head -10
done
