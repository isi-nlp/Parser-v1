#!/bin/bash

lang=$1
gpu=$2

echo "============================================================================"
echo "$lang - guo.id.punk"
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id.cfg \
--test --zero_test_pos=True --zero_wrd_emb=False \
> saves/res.$lang.guo.id.punk

echo "============================================================================"
echo "$lang - unk.id.punk"
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id.cfg \
--test --zero_test_pos=True --zero_wrd_emb=True \
> saves/res.$lang.unk.id.punk

echo "============================================================================"
echo "$lang - unk.emb.punk"
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-unk-emb.cfg \
--test --zero_test_pos=True --zero_wrd_emb=True \
> saves/res.$lang.unk.emb.punk