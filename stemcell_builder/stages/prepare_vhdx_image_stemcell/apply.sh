#!/usr/bin/env bash
#


set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

rm -f $work/root.vhd
rm -f $work/0.vhd 

# targeting xenserver vhd acceptable format. use img => qcow2 => raw
qemu-img convert -c -O qcow2 $work/${stemcell_image_name} $work/0.qcow2
qemu-img convert -O raw $work/0.qcow2 $work/0.raw

#add faketime
sudo apt-get install -y faketime


#vhd-utils does only raw => fixed, or fixed => dynamic. chaining 2 conversions
vhd-util convert -i $work/0.raw -s 0 -t 1  -o $work/0.vhd 
faketime '2010-01-01' vhd-util convert -i $work/0.vhd -s 1 -t 2  -o $work/root.vhd 

#Verification: 
vhd-util check -n $work/root.vhd 

pushd $work
#tar zcf stemcell/image root.vhd
bzip2 -c root.vhd > stemcell/image
popd
