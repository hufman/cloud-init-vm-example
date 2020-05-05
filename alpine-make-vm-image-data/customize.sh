#!/bin/sh

_step_counter=0
step() {
        _step_counter=$(( _step_counter + 1 ))
        printf '\n\033[1;36m%d) %s\033[0m\n' $_step_counter "$@" >&2  # bold cyan
}

step 'Set up networking'
rc-update add networking   # start up the rest of the networking after cloud-init

step 'Set up extra mounts'
mkdir -p /var/lib/cloud/seed/nocloud
echo 'cloud-init /var/lib/cloud/seed/nocloud 9p trans=virtio,version=9p2000.L,rw 0 0' >> /etc/fstab

step 'Enable services'
rc-update add cloud-init-local
rc-update add cloud-init
rc-update add cloud-config
rc-update add cloud-final
rc-update add acpid

# Alpine's version of cloud-init has some bugs
step 'Patch cloud-init'
sed -i "s/'--all'/'-a'/" /usr/lib/python3.8/site-packages/cloudinit/distros/alpine.py
# https://bugs.launchpad.net/cloud-init/+bug/1876183
sed -i "/if key == 'netmask':/,+1 d" /usr/lib/python3.8/site-packages/cloudinit/net/eni.py
sed -i "/if key == 'address':/,+1 d" /usr/lib/python3.8/site-packages/cloudinit/net/eni.py
