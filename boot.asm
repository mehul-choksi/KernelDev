; Reference for all interrupts: https://www.ctyme.com/intr/int.htm

; Using org 0x7c00 is a bad practice. Instead set it to 0 and load the appropriate address values in registers
;ORG 0x7c00 ; Starting address of bootloader

ORG 0
BITS 16 ; tells that we're using a 16 bit address space 

_start:
    jmp short start ; Short jump to the start label
    nop ; No operation

times 33 db 0 ; Forcefully fill the 33 bytes with all 0s, so that Bios Parameter Block writes dont interfere with our bootloader's address space.

start:
jmp 0x7c0:intialization ; Intialize code segment to 0x7c0 as well

intialization:
    cli ; Disable hardware interrupts for critical section
    ; Cannot directly write values to segment register - must use a buffer register like ax
    mov ax, 0x7c0
    mov ds, ax
    mov es, ax
    ; This will ensure that ds and es segment x 16 will point to 0x7c00
    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti ; Re-enable hardware interrupts
    mov si, message ; Copy the value of message into register si
    ;int 0x10    ; Invoke the bios. ah 0eh will print the value in al register ?
    call print
    jmp $ ; Keep jumping to itself ? What is the rationale behind this? its not like we're looping infinitely

print:
    mov bx, 0 ; Set page number to 0?
.loop:
    lodsb   ; Loads the next character from si register into the al register. 
    cmp al, 0 ; If al register has a value 0, that means end of string has been reached, no need to print
    je .done
    call printChar
    jmp .loop
.done:
    ret
printChar:
    mov ah, 0eh ;Value in ah must be 0eh to print upon invoking 0x10
    int 0x10
    ret

message: db 'Hello World!', 0   ; Create bytes from the string Hello World, and add the null terminator 0 at the end

times 510-($ - $$) db 0 ; Pad the remaining code space with 0s
; Intel processors are little endian - 0x55AA will be written as 0xAA55
; Why do we ensure that the code is filled up to first 510 bytes?
; Reason: Boot signature must be at byte 511 and 512
dw 0xAA55   ; dw is double word - 2 bytes