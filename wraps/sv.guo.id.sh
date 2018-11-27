#!/bin/bash
#SBATCH --ntasks=60
#SBATCH --mem=40GB
#SBATCH --mem-per-cpu=2GB
#SBATCH --time=150:00:00
#SBATCH --partition=isi

cd /home/rcf-40/rac_815/dep-par-biaffine/
source /home/rcf-40/rac_815/.bash_profile

il=sv
wrd_emb=guo
clt_opt=id

python network.py --config_file config/$il.$wrd_emb.$clt_opt.cfg > saves/$il-$wrd_emb-$clt_opt/train.log
