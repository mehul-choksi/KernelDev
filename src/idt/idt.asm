section .asm

global load_idt

load_idt:
    push ebp ; Existing value of base pointer is pushed on stack, to be retrieved later
    mov ebp, esp ; Move the stack pointer to base pointer. Stack pointer tracks function address
    mov ebx, [ebp + 8] ; ebp pts to stack, which has the address of 1st instruction. ebp + 4 has the return address of function 
    ; ebp + 8 has the first function param
    lidt [ebx]  ; Load interrupt descriptor table with value present in ebx
    pop ebp ;Retrieve original value of ebp
    ret