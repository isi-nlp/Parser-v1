#!/bin/bash

lang=$1
gpu=$2

echo "============================================================================"
echo "$lang - guo.id.gold" >> saves/res.$lang.guo-id-gold
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-gdpos.cfg \
--test --zero_test_pos=False --zero_wrd_emb=False \
>> saves/res.$lang.guo-id-gold 


echo "============================================================================"
echo "$lang - guo.id.cipher" >> saves/res.$lang.guo-id-gold 
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-gdpos.cipher.cfg \
--test --zero_test_pos=False --zero_wrd_emb=False \
>> saves/res.$lang.guo-id-gold 


echo "============================================================================"
echo "$lang - guo.id.unk" >> saves/res.$lang.guo-id-gold
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-gdpos.cipher.cfg \
--test --zero_test_pos=True --zero_wrd_emb=False \
>> saves/res.$lang.guo-id-gold 

