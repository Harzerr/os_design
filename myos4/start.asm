	[BITS 16]
	GLOBAL start
	EXTERN __mymain
	GLOBAL _puts
start: JMP entry
entry:mov ax,cs
	mov ds,ax
	mov es,ax
	mov ax,0
	mov ss,ax
	mov sp,0x7e00
	lea si,msg
ploop:lodsb
	cmp al,0
	je fin
	mov ah,0x0e
	mov bx,0x0f
	int 0x10
	jmp ploop
fin: JMP __mymain
msg: DB "myos is running! -start.asm",0x0a,0x0a,0x0a,0
_puts:
	mov bp,sp
	mov si,[BP+0x04]
loop2:lodsb 
	cmp al,0
	jz loop3
	mov ah, 0x0e
	mov bl,0x07
	int 0x10
	jmp loop2
loop3:db 0x66
	ret