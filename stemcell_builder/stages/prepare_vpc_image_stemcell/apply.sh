#!/usr/bin/env bash
#
# Copyright (c) 2009-2012 VMware, Inc.

set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

rm -f $work/root.vhd

# targeting xenserver vhd acceptable format
qemu-img convert -O vpc -o subformat=dynamic $work/${stemcell_image_name} $work/root.vhd

pushd $work
tar zcf stemcell/image root.vhd
popd
