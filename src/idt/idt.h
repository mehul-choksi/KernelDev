#ifndef IDT_H
#define IDT_H

#include <stdint.h>


struct idt_descriptor {
    uint16_t offset1; // Bits 0 - 15 for offset
    uint16_t selector; // Selector bits to point to entry in GDT / LDT
    uint8_t zero; // Unused bits
    uint8_t type; // Gate type, Storage segment,  DPL and present bit
    uint16_t offset2; // Bits 16-31 for offset
}__attribute__((packed));

struct idtr {
    uint16_t limit; // Length of IDT - 1
    uint32_t base; // Starting address of IDT
}__attribute__((packed));

void initialize_idt();

#endif