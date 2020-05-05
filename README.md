When initializing a cloud VM with the local NoCloud cloud-init data source,
most resources suggest building an ISO image.
However, this adds an extra step during iteration and development, so
here is a method to use virtio-9p to mount a directory for cloud-init.

The VM image must be pre-configured to try to mount the virtio-9p volume
to the proper directory, and then the hypervisor must provide such a volume.
The NoCloud config provider will pick up the data and configure it as normal.
