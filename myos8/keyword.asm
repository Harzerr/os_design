	[BITS	16]
	GLOBAL  _mygetc
	GLOBAL  _ascandsyscode;打印按键ASCII码和系统扫描码的函数
	EXTERN  __sysscancode
_mygetc:;以阻塞方式读取一个按键值
		PUSH	SI
		MOV	AH,0x10
		INT	0x16	;阻塞式读取一个按键值
		LEA     SI,__sysscancode
		MOV	[SI],AH
		POP	SI
		DB	0x66
		RET
_ascandsyscode:	JMP	continue;打印按键的ASCII码和系统扫描码
continue:	MOV	AH,0x10
		INT	0x16    ;从键盘缓冲区读取键值
		MOV	DH,AH
		CALL 	print16  ;先打印系统扫描码
		MOV	DH,AL
		CALL	print16  ;再打印ASCII码
		MOV	AH,0x0e
		MOV	BL,0x07
		MOV	AL,' '
		INT	0x10     ;打印一个空格
		JMP	continue
print16:	PUSH	AX      ;保存一下AX
		MOV	AH,0x0e
		MOV	BL,0x07
		MOV	DL,DH   ;要打印的字节在DH
		MOV	CL,4
		SHR	DH,CL   ;先打印高4位
		CMP	DH,09
		JBE	loop1   ; 如果0~9，只加0x30
		ADD	DH,7     ;否则是A~F，多加一个7
loop1:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		MOV	DH,DL  ;再打印低4位
		AND	DH,0x0f
		CMP	DH,09
		JBE	loop2
		ADD	DH,7
loop2:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		POP	AX	;恢复AX
		RET









