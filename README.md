When initializing a cloud VM with the local NoCloud cloud-init data source,
most resources suggest building an ISO image.
However, this adds an extra step during iteration and development, so
here is a method to use virtio-9p to mount a directory for cloud-init.
