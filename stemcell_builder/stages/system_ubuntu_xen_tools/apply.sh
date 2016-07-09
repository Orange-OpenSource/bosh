#!/usr/bin/env bash
#


set -e

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

#download xenserver tools iso distrib to extract tools

rm -rf ${work}/xenserver
mkdir ${work}/xenserver
wget http://boot.rackspace.com/files/xentools/xs-tools-6.5.0-20200.iso -O ${work}/xenserver/xs-tools-6.5.0-20200.iso  



#mount iso
iso_mount_path=`mktemp -d`
echo "Mounting xenserver iso from at $iso_mount_path"
mount -o loop -t iso9660 ${work}/xenserver/xs-tools-6.5.0-20200.iso $iso_mount_path
add_on_exit "umount $iso_mount_path"


#extract and copy tools
cp $iso_mount_path/Linux/xe-guest-utilities_*.deb $chroot/tmp
cp $iso_mount_path/Linux/install.sh $chroot/tmp


#install tools in chroot
#run_in_chroot $chroot "sudo dpkg -i /tmp/xe-guest-utilities_6.5.0-1427_amd64.deb"
run_in_chroot $chroot "sudo dpkg -i /tmp/install.sh"
