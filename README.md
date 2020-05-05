When initializing a cloud VM with the local NoCloud cloud-init data source,
most resources suggest building an ISO image.
However, this adds an extra step during iteration and development, so
here is a method to use virtio-9p to mount a directory for cloud-init.

The VM image must be pre-configured to try to mount the virtio-9p volume
to the proper directory, and then the hypervisor must provide such a volume.
The NoCloud config provider will pick up the data and configure it as normal.

Important Bits
--------------

The VM image must be configured to mount the virtio-9p volume during boot:

> #### **/etc/fstab**
```
# <fs>          <mountpoint>                  <type>  <opts>                           <dump/pass>
cloud-init      /var/lib/cloud/seed/nocloud   9p      trans=virtio,version=9p2000.L,ro 0 0
```

Next, the hypervisor must provide a virtio-9p volume there:

> #### **libvirt-domain.xml**
```
<domain type='kvm'>
  <devices>
...
    <filesystem type='mount' accessmode='squash'>
      <source dir='/vms/alpine-example/cloud-init'/>
      <target dir='cloud-init'/>
      <readonly/>
      <address type='pci' domain='0x0000' bus='0x02' slot='0x06' function='0x0'/>
    </filesystem>
...
  </devices>
</domain>
```
