.RECIPEPREFIX := >
CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy
CFLAGS = -m64 -ffreestanding -O2 -Wall -Wextra -fno-pie -fno-stack-protector
LDFLAGS = -nostdlib -z max-page-size=0x1000 -T linker.ld

all: kernel.bin

boot.o: boot.asm
>$(AS) -f elf64 $< -o $@

kernel.o: kernel.c
>$(CC) $(CFLAGS) -c $< -o $@

kernel.elf: boot.o kernel.o linker.ld
>$(LD) $(LDFLAGS) -o $@ boot.o kernel.o

kernel.bin: kernel.elf
>$(OBJCOPY) -O binary $< $@

clean:
>rm -f *.o *.elf *.bin

.PHONY: all clean
