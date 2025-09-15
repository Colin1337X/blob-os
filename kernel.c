#include <stddef.h>
#include <stdint.h>

static inline void hlt_loop(void) {
    while (1) {
        __asm__ __volatile__("hlt");
    }
}

void kernel_main(void) {
    const char *msg = "Hello from blob-os!";
    volatile uint16_t *vga = (uint16_t *)0xB8000;
    for (size_t i = 0; msg[i]; ++i) {
        vga[i] = (uint16_t)msg[i] | 0x0700;
    }
    hlt_loop();
}
