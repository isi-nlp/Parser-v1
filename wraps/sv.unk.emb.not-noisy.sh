#!/bin/bash
#SBATCH --ntasks=40
#SBATCH --mem=40GB
#SBATCH --mem-per-cpu=2GB
#SBATCH --gres=gpu:p100:1
#SBATCH --time=150:00:00
#SBATCH --partition=isi

cd /home/rcf-40/rac_815/dep-par-biaffine/
source /home/rcf-40/rac_815/.bash_profile

exp_id=sv-unk-emb-not-noisy

python network.py --config_file config/$exp_id.cfg > saves/$exp_id/train.log
