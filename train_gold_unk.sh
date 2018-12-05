#!/bin/bash

lang=$1
gpu=$2

echo "$lang-muse-emb-gold"

CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-muse-emb-gold.cfg

echo ""
echo "$lang-muse-emb-unk"

CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-muse-emb-unk.cfg
