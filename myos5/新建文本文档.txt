nasm mbr.asm -o mbr.bin
nasm -f elf start.asm -o start.o
nasm -f elf display.asm -o display.o
gcc -c myos.c -o myos.o 
ld -s --entry=start -Ttext=0x0 start.o display.o myos.o -o myos.exe 
objcopy -O binary myos.exe myos.com
writea mbr.bin A.img 1
writea myos.com A.img 2