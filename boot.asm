; boot.asm - switch to 64-bit long mode and call kernel_main

; Multiboot header for GRUB
section .multiboot
align 8
    dd 0x1BADB002             ; magic
    dd 0                     ; flags
    dd -(0x1BADB002)         ; checksum

section .text
bits 32
global start
extern kernel_main

start:
    cli
    mov esp, stack_top

    ; load GDT with 64-bit code segment
    lgdt [gdt_descriptor]

    ; enable PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; set up page tables for identity mapping
    mov eax, pml4
    mov cr3, eax

    ; enable long mode via EFER
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; enable paging
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax

    ; far jump to 64-bit code segment
    jmp 0x08:long_mode_start

bits 64
long_mode_start:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, stack_top

    call kernel_main

.hang:
    hlt
    jmp .hang

section .bss
align 16
stack_bottom:
    resb 16384
stack_top:

section .data
align 4096
pml4:
    dq pdpt + 0x03
align 4096
pdpt:
    dq 0x83

section .rodata
align 8
gdt:
    dq 0
    dq 0x00AF9A000000FFFF
    dq 0x00AF92000000FFFF
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt - 1
    dq gdt

section .note.GNU-stack noalloc noexec nowrite progbits
