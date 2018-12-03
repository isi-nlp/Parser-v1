#!/bin/bash

lang=$1
gpu=$2

CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id.cfg \
--test --unk_pos=True --zero_wrd_emb=False \
> saves/res.guo.id.punk


CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id.cfg \
--test --unk_pos=True --zero_wrd_emb=True \
> saves/res.unk.id.punk

CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-unk-emb.cfg \
--test --unk_pos=True --zero_wrd_emb=True \
> saves/res.unk.emb.punk