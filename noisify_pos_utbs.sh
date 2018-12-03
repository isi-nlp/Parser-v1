#!/bin/bash

langs="de fr it es pt sv"
for ll in $langs; do
  echo "=================================================="
  echo "$ll"
  python3 noisify_pos.py -i data/$ll/train.all.fix -tid ut > data/$ll/train.all.fix.noisy
  python3 noisify_pos.py -i data/$ll/dev.lc.lid -tid ut > data/$ll/dev.lc.lid.noisy
  python3 noisify_pos.py -i data/$ll/test.lc.lid -tid ut > data/$ll/test.lc.lid.noisy
done