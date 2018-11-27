#!/bin/bash

il=$1
wrd_emb=$2
clt_opt=$3

outfile="$il".$wrd_emb.$clt_opt.sh

echo "#!/bin/bash" > $outfile
echo "#SBATCH --ntasks=60" >> $outfile
echo "#SBATCH --mem=40GB" >> $outfile
echo "#SBATCH --mem-per-cpu=2GB" >> $outfile
echo "#SBATCH --time=150:00:00" >> $outfile
echo "#SBATCH --partition=isi" >> $outfile
echo "" >> $outfile
echo "cd /home/rcf-40/rac_815/dep-par-biaffine/" >> $outfile
echo "source /home/rcf-40/rac_815/.bash_profile" >> $outfile
echo "" >> $outfile

echo "il=$il" >> $outfile
echo "wrd_emb=$wrd_emb" >> $outfile
echo "clt_opt=$clt_opt" >> $outfile
echo "" >> $outfile


cat ../config/tmp.baseline.cfg | \
sed "s/il-id/$il/" | \
sed "s/exp-dir/$il-$wrd_emb-$clt_opt/" |
sed "s/clt-opt/$clt_opt/" \
> ../config/$il.$wrd_emb.$clt_opt.cfg


echo 'python network.py --config_file config/$il.$wrd_emb.$clt_opt.cfg > saves/$il-$wrd_emb-$clt_opt/train.log' >> $outfile

