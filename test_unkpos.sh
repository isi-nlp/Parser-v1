#!/bin/bash

lang=$1
gpu=$2

echo "============================================================================"
echo "$lang - guo.id.tr=unkpos"

echo "$lang - guo.id.gold" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cfg \
--test --zero_wrd_emb=False --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - guo.id.cipher" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cipher.cfg \
--test --zero_wrd_emb=False --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - guo.id.unkpos" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cfg \
--test --zero_wrd_emb=False --zero_test_pos=True | \
tail -10 >> saves/res.$lang.unkpos



echo "============================================================================"
echo "$lang - unk.id.tr=unkpos"

echo "$lang - unk.id.gold" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cfg \
--test --zero_wrd_emb=True --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - unk.id.cipher" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cipher.cfg \
--test --zero_wrd_emb=True --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - unk.id.unkpos" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-guo-id-unkpos.cfg \
--test --zero_wrd_emb=True --zero_test_pos=True | \
tail -10 >> saves/res.$lang.unkpos



echo "============================================================================"
echo "$lang - unk.emb.tr=unkpos"

echo "$lang - unk.emb.gold" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-unk-emb-unkpos.cfg \
--test --zero_wrd_emb=True --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - unk.emb.cipher" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-unk-emb-unkpos.cipher.cfg \
--test --zero_wrd_emb=True --zero_test_pos=False | \
tail -10 >> saves/res.$lang.unkpos

echo "$lang - unk.emb.unkpos" >> saves/res.$lang.unkpos
CUDA_VISIBLE_DEVICES=$gpu python2 network.py --config_file=config/$lang-unk-emb-unkpos.cfg \
--test --zero_wrd_emb=True --zero_test_pos=True | \
tail -10 >> saves/res.$lang.unkpos

