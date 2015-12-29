#!/usr/bin/env bash

base_dir=$(readlink -nf $(dirname $0)/../..)
source $base_dir/lib/prelude_apply.bash

agent_settings_file=$chroot/var/vcap/bosh/agent.json


#source is http registry
#key to find instance in registry is servername
#for cloudstack, infrastructure networking is dhcp (set by registry, use_dhcp=true


cat > $agent_settings_file <<JSON
{
  "Platform": {
    "Linux": {
      "CreatePartitionIfNoEphemeralDisk": true,
      "DevicePathResolutionType": "virtio"
    }
  },
  "Infrastructure": {
    "Settings": {
      "Sources": [
        {
          "Type": "HTTP",
          "URI": "http://169.254.169.254"
        }
      ],

      "UseServerName": true,
      "UseRegistry": true
    }

  }
}
JSON

#temporary patch to access vm for troubleshooting

run_in_chroot $chroot "
mkdir -p /home/vcap/.ssh
chmod 700 /home/vcap/.ssh
chown vcap:vcap /home/vcap/.ssh
"
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtmLIgm86izRre88+0Poo45CZGPaxgwpPi5fnJoclaqnIj2a+dSZrwsZ9suMiwjK8x7lYvJz5gunLrReF79gLsIxhhKKiMem1gPcvCz2TNTgMKoIwhupp8sabbfVgjuGIrQXIAsNkOdAZHRpsZnX47NTSNhsvKibgSxRntUEP1LGNT01gWu0SeIGdyXBRLFPcAWaL1nrQDt0oPRkiIV5A+LArAHLT3HxilQflpX3GlUIaZ0KP5oQlLZvoLKvO8xSxfyJPYi+pRNtTNuM4ew2yr9/nmpujctUCg9K2uAlGZgJBsy6Qoeega0JXfyDJxOvbOBqEw9ylT7m+GoEPA0YNnS0/RlZQFPybges4ysxXfERbFe4KkL8tGMaFgG6LinMXZz6Zl1OeGz6WMqcF1o41cedpJ87N8cKl0z7I4+sE9glSS3/z0whXD0MOK+Ov4D4B5+wc5DBaMd+kA89tdxpgrgZI89Ppj1Yw9f24Ai36aQEAbkyLd79U5gpqCznHx01/LtRp804dUA2lmnifgQ6jRLsLfcm9x5Qs6HP2lCHNJTqqkI2vmxDspjXOI2HMMUYUVJbfrxSumU9dfuOAWgv0t8JRJ+48sy7RH109f5On4LZkFOdEwcIVWH7gv5hRmtU7EWfLRASQDZ08V2UrM8ao15jnJk8nDQvGayPjEuHvnoQ== your_email@example.com" >> $chroot/home/vcap/.ssh/authorized_keys 

run_in_chroot $chroot "
chown vcap:vcap /home/vcap/.ssh/authorized_keys 
chmod 600 /home/vcap/.ssh/authorized_keys 
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh
"

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtmLIgm86izRre88+0Poo45CZGPaxgwpPi5fnJoclaqnIj2a+dSZrwsZ9suMiwjK8x7lYvJz5gunLrReF79gLsIxhhKKiMem1gPcvCz2TNTgMKoIwhupp8sabbfVgjuGIrQXIAsNkOdAZHRpsZnX47NTSNhsvKibgSxRntUEP1LGNT01gWu0SeIGdyXBRLFPcAWaL1nrQDt0oPRkiIV5A+LArAHLT3HxilQflpX3GlUIaZ0KP5oQlLZvoLKvO8xSxfyJPYi+pRNtTNuM4ew2yr9/nmpujctUCg9K2uAlGZgJBsy6Qoeega0JXfyDJxOvbOBqEw9ylT7m+GoEPA0YNnS0/RlZQFPybges4ysxXfERbFe4KkL8tGMaFgG6LinMXZz6Zl1OeGz6WMqcF1o41cedpJ87N8cKl0z7I4+sE9glSS3/z0whXD0MOK+Ov4D4B5+wc5DBaMd+kA89tdxpgrgZI89Ppj1Yw9f24Ai36aQEAbkyLd79U5gpqCznHx01/LtRp804dUA2lmnifgQ6jRLsLfcm9x5Qs6HP2lCHNJTqqkI2vmxDspjXOI2HMMUYUVJbfrxSumU9dfuOAWgv0t8JRJ+48sy7RH109f5On4LZkFOdEwcIVWH7gv5hRmtU7EWfLRASQDZ08V2UrM8ao15jnJk8nDQvGayPjEuHvnoQ== your_email@example.com" >> $chroot/root/.ssh/authorized_keys 

run_in_chroot $chroot "
chown root:root /root/.ssh/authorized_keys 
chmod 600 /root/.ssh/authorized_keys 
"

