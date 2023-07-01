
[BITS 16]
GLOBAL _mygetc
EXTERN __sysscancode
_mygetc:;以阻塞方式读取一个按键值
	PUSH SI
	MOV AH,0x10
	INT 0x16 ;阻塞式读取一个按键值
	LEA SI,__sysscancode
	MOV [SI],AH
	POP SI
	DB 0x66
RET