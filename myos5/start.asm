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
	mov sp,0x8000
    JMP __mymain
