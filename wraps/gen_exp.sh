#!/bin/bash

il=$1
base=$2
clt_opt=$3

outfile="$il".$base.$clt_opt.sh

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
echo "base=$base" >> $outfile
echo "" >> $outfile

cat ../config/tmp.$base.cfg | \
sed "s/il-id/$il/" | sed "s/exp-dir/$base-$il/" |
sed "s/clt-opt/$clt_opt/" \
> ../config/$il.$base.$clt_opt.cfg


echo 'python network.py --config_file config/$base.$il.cfg > saves/$base-$il/train.log' >> $outfile

