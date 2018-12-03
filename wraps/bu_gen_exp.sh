#!/bin/bash

set -e

il=$1
clt_opt=$2
zwe_opt=$3 # True,False
noise_opt=$4 # not-noisy, noisy

use_we="guo"

if [ $zwe_opt = "True" ]; then
	use_we="unk"
fi

exp_id=""
if [ $noise_opt = "noisy" ]; then
	exp_id="$il-$use_we-$clt_opt-$noise_opt"
	noise_opt=".$noise_opt"
else
	noise_opt=""
	exp_id="$il-$use_we-$clt_opt"
fi

outfile="$il".$use_we.$clt_opt$noise_opt.sh


echo "#!/bin/bash" > $outfile
echo "#SBATCH --ntasks=40" >> $outfile
echo "#SBATCH --mem=40GB" >> $outfile
echo "#SBATCH --mem-per-cpu=2GB" >> $outfile
echo "#SBATCH --gres=gpu:p100:1" >> $outfile
echo "#SBATCH --time=150:00:00" >> $outfile
echo "#SBATCH --partition=isi" >> $outfile
echo "" >> $outfile
echo "cd /home/rcf-40/rac_815/dep-par-biaffine/" >> $outfile
echo "source /home/rcf-40/rac_815/.bash_profile" >> $outfile
echo "" >> $outfile



echo "exp_id=$exp_id" >> $outfile
echo "" >> $outfile

test_orig="test.lc.lid"

# malopa original
cat ../config/tmp.baseline.cfg | \
sed "s/il-id/$il/" | \
sed "s/-train-noise-opt/$noise_opt/" | \
sed "s/-dev-noise-opt/$noise_opt/" | \
sed "s/-test-noise-opt/$noise_opt/" | \
sed "s/exp-dir/$exp_id/" | \
sed "s/clt-opt/$clt_opt/" | \
sed "s/zwe-opt/$zwe_opt/" | \
sed "s/test-file/$test_orig/" \
> ../config/$exp_id.cfg

# malopa - cipher
cat ../config/tmp.baseline.cfg | \
sed "s/il-id/$il/" | \
sed "s/-train-noise-opt/$noise_opt/" | \
sed "s/-dev-noise-opt/$noise_opt/" | \
sed "s/-test-noise-opt//" | \
sed "s/exp-dir/$exp_id/" | \
sed "s/clt-opt/$clt_opt/" | \
sed "s/zwe-opt/$zwe_opt/" | \
sed "s/test-file/test.conllu.cipher/" \
> ../config/$exp_id.cipher.cfg


mkdir -p ../saves/$exp_id

echo 'python network.py --config_file config/$exp_id.cfg > saves/$exp_id/train.log' >> $outfile
