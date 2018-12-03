#!/bin/bash

set -e

langs="de fr it es pt sv"
for ll in $langs; do
  echo "=================================================="
  echo "$ll"
  cat data/$ll/train.all.fix | cut -f 4 | sort -b | \
  uniq -c | sort -nbr > data/$ll/pos.counts
  
  python3 noisify_pos.py -i data/$ll/train.all.fix -tid ut -c data/$ll/pos.counts > data/$ll/train.all.fix.noisy
  python3 noisify_pos.py -i data/$ll/dev.lc.lid    -tid ut -c data/$ll/pos.counts > data/$ll/dev.lc.lid.noisy
  python3 noisify_pos.py -i data/$ll/test.lc.lid   -tid ut -c data/$ll/pos.counts > data/$ll/test.lc.lid.noisy
done