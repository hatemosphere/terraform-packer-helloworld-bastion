#!/usr/bin/env bash
set -x

# Remove Packages
apt-get -y autoremove --purge
apt-get -y clean
rm -rf /tmp; mkdir /tmp; chmod 1777 /tmp

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/ubuntu/.bash_history
rm -f /root/.ansible

# Clean up log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# cleunup authorized keys
sed -i "/packer.*/d" /home/ubuntu/.ssh/authorized_keys
sed -i "/packer.*/d" /root/.ssh/authorized_keys
