#!/bin/bash

RL=$1
gpu=$2

CUDA_VISIBLE_DEVICES=$gpu \
python3 /disk/ocean/rcardenas/MUSE/unsupervised.py --src_lang $RL --tgt_lang en --src_emb wrd-emb/cc.$RL.300.vec.gz \
--tgt_emb wrd-emb/cc.en.300.vec.gz --n_refinement 5 --emb_dim 50 \
--seed 42 --exp_path wrd-emb --exp_name $RL-en --exp_id $RL-en --cuda True
