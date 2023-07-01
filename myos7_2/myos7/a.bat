nasm mbr.asm -o mbr.bin
nasm -f elf start.asm -o start.o
nasm -f elf display.asm -o display.o
nasm -f elf keyword.asm -o keyword.o
nasm -f elf time.asm -o time.o
gcc -c myos.c -o myos.o
gcc -c disp.c -o disp.o
gcc -c key.c -o key.o 
ld -s --entry=start -Ttext=0x0 start.o display.o keyword.o disp.o key.o time.o myos.o -o myos.exe 
objcopy -O binary myos.exe myos.com
writea mbr.bin A.img 1
writea myos.com A.img 2
