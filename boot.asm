/* === BOOTLOADER (Assembly, 512-byte MBR stub) === */
/* File: boot.asm */

; A minimal bootloader that loads the kernel from a FAT32 partition
[bits 16]
[org 0x7c00]
start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; Print "Loading Sovereign OS..."
    mov si, msg
    call print

    ; Load kernel from FAT32 (stubbed placeholder for now)
    ; Real implementation will require BIOS INT13h, FAT32 parsing
    ; For prototype purposes: jump to fixed memory where kernel is loaded
    jmp 0x1000:0000

print:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0e
    int 0x10
    jmp print
.done:
    ret

msg db "Loading Sovereign OS...", 0

times 510-($-$$) db 0
    dw 0xAA55 ; Boot signature
