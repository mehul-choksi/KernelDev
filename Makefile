FILES = ./build/kernel/kernel.asm.o ./build/kernel/kernel.o ./build/idt/idt.asm.o ./build/idt/idt.o
INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc
all: ./bin/boot.bin ./bin/kernel.bin
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=512 count=100 >> ./bin/os.bin

./bin/kernel.bin : $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernel/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernel/kernelfull.o

./bin/boot.bin : ./src/boot.asm
	nasm -f bin ./src/boot.asm -o ./bin/boot.bin

./build/kernel/kernel.asm.o: ./src/kernel/kernel.asm
	nasm -f elf -g ./src/kernel/kernel.asm -o ./build/kernel/kernel.asm.o

./build/kernel/kernel.o : ./src/kernel/kernel.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./src/kernel/kernel.c -o ./build/kernel/kernel.o

./build/idt/idt.asm.o: ./src/idt/idt.asm
	nasm -f elf -g ./src/idt/idt.asm -o ./build/idt/idt.asm.o

./build/idt/idt.o : ./src/idt/idt.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -I./src/idt -std=gnu99 -c ./src/idt/idt.c -o ./build/idt/idt.o

./build/memory/memory.o : ./src/memory/memory.c
	i686-elf-gcc $(INCLUDES) $(FLAGS) -I./src/memory -std=gnu99 -c ./src/memory/memory.c -o ./build/memory/memory.o

clean:
	rm -rf ./bin/kernel.bin
	rm -rf ./bin/boot.bin
	rm -rf ./bin/os.bin
	rm -rf ./build/kernel/kernelfull.o
	rm -rf ./build/kernel/kernel.o
	rm -rf ./build/kernel/kernel.asm.o
	rm -rf ./build/idt/idt.asm.o
	rm -rf $(FILES)