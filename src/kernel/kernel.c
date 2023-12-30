#include "kernel.h"
#include "../idt/idt.h"
#include <stdint.h>
#include <stddef.h>

uint16_t* video_mem = 0;

uint16_t make_terminal_char(char c, char color){
    return (color << 8) | c;
}

void put_char(int y, int x, char c, char color){
    video_mem[(y * VGA_WIDTH) + x] = make_terminal_char(c, color);
}

void initialize_terminal(){
    video_mem = (uint16_t*)0XB8000;

    for(int y = 0; y < VGA_HEIGHT; y++){
        for(int x = 0; x < VGA_WIDTH; x++){
            put_char(y, x, ' ', 0);
        }
    }
}

size_t strlen(char* str){
    size_t len = 0;
    while(str[len]){
        len++;
    }
    return len;
}

void printMessage(int starty, int startx, char* msg){
    size_t msglen = strlen(msg);
    // int startPoint = starty * VGA_WIDTH + startx;
    int ptr = 0;
    for(int i = startx; i < startx + msglen; i++){
        put_char(starty, i, msg[ptr], 2);
        ptr++;
    }
}

// Simplified print function
void print(char* msg){
    for(int i = 0; i < strlen(msg); i++){
        put_char(0, i, msg[i], 2);
    }
}

void kernel_main(){
    initialize_terminal();

    char* msg = "MEHUL";
    printMessage(0, 0, msg);

    // Initialize the interrupt descriptor table
    initialize_idt();

}