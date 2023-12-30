#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel/kernel.h"

struct idt_descriptor idt[MAX_INTERRUPT_COUNT];
struct idtr idtr;

extern void load_idt(struct idtr *ptr);
extern void problem();

void idt_zero(){
    print("Divide by zero error\n");
}

// Todo: fix memset linking
void* memset(void* ptr, int c, size_t size){
    char* cast = (char*)ptr;

    for(int i = 0; i < size; i++){
        cast[i] = c;
    }
    return ptr;
}

void set_idt_values(int interrupt_no, void* address){
    struct idt_descriptor* target = &idt[interrupt_no];
    target->offset1 = (uint32_t)address & 0x0000ffff;
    target->offset2 = (uint32_t)address >> 16;
    target->selector = KERNEL_CODE_SELECTOR;
    target->zero = 0x00;
    target->type = 0xee; // DPL 3(11), Present : 1, Storage segment (0 for interrupt gates) Gate type: interrupt, 32-bit (1110), 

}

void initialize_idt(){
    memset(idt, 0, sizeof(idt));
    idtr.limit = sizeof(idt) - 1;
    idtr.base = (uint32_t)idt;
    // Define interrupt routine for int 0 as idt_zero
    set_idt_values(0, idt_zero);
    load_idt(&idtr);
    problem();
}

