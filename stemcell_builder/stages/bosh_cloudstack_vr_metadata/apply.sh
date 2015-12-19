#!/usr/bin/env bash

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

#copy dhcp metadata script in stemcell
cp $(dirname $0)/assets/vr_metadata $chroot/etc/dhcp/dhclient-exit-hooks.d/vr-metadata