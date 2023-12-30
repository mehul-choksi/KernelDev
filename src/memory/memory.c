#include "memory.h"
#include <stddef.h>

void* memset(void* ptr, int c, size_t size){
    char* cast = (char*)ptr;
    for(int i = 0; i < size; i++){
        cast[i] = c;
    }
    return ptr;
}