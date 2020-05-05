#!/bin/sh
set -e

test -e alpine-make-vm-image/alpine-make-vm-image || git submodule update --init

# This builds an Alpine VM
# The important bit is added in /etc/fstab with customize.sh
./alpine-make-vm-image/alpine-make-vm-image --image-format qcow2 --image-size 10G --serial-console --script-chroot --repositories-file alpine-make-vm-image-data/repositories --initfs-features "scsi virtio" --packages "bridge cloud-init docker openssh" alpine-base-image.qcow2 alpine-make-vm-image-data/customize.sh

# This prepares the VM-specific disk based on the above image
qemu-img create -f qcow2 -b alpine-base-image.qcow2 alpine-example.qcow2
