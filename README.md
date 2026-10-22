# blob-os

A tiny 64-bit toy kernel that prints a message to the VGA text buffer.

## Building

```sh
make
```

The build produces `kernel.bin`, which can be loaded by a Multiboot-compliant bootloader such as GRUB.
