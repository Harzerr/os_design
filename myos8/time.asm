	GLOBAL	_initIRQ1C
	GLOBAL	_printIVT
	[BITS	16]
printtime:	PUSH	AX
		PUSH	CX
		PUSH	SI
		PUSH	DI
		PUSH	DS
		PUSH	ES
		MOV	AX,0
		MOV	DS,AX
		MOV	AX,0xb800
		MOV	ES,AX
		MOV	SI,400		;指向毫秒
		MOV	AL,[DS:SI]	;取出毫秒
		INC	AL		;毫秒增1
		MOV	[DS:SI],AL	;送回去
		CMP	AL,20		;到1秒吗？		
		JL	loop0		;不到，直接显示
		MOV	AL,0		;到1秒，毫秒清零
		MOV	[DS:SI],AL
		INC	SI		;指向秒
		MOV	AL,[DS:SI]	;取出秒
		INC	AL		;秒增1
		MOV	[DS:SI],AL	;送回去
		CMP	AL,60		;到1分吗？
		JL	loop0		;不到，直接显示
		MOV	AL,0		;到1分，秒清零
		MOV	[DS:SI],AL
		INC	SI		;指向分
		MOV	AL,[DS:SI]	;取出分
		INC	AL		;分增1
		MOV	[DS:SI],AL	;送回去
		CMP	AL,60		;到1时吗？	
		JL	loop0		;不到，直接显示
		MOV	AL,0		;到1时，分清零
		MOV	[DS:SI],AL
		INC	SI		;指向时
		MOV	AL,[DS:SI]	;取出时
		INC	AL		;时增1		
		MOV	[DS:SI],AL	;送回去
		CMP	AL,24		;到1天吗？
		JL	loop0		;不到，直接显示
		MOV	AL,0		;到1天，时清零
		MOV	[DS:SI],AL	
loop0:	MOV	DI,3972		;开始显示
		LEA	SI,403
		MOV	CL,10
		MOV	AL,'['		;先显示左方括号
		MOV	[ES:DI],AL
		ADD	DI,2
		MOV	AL,[DS:SI]	;取出时
		MOV	AH,0		;扩展成16位
		DIV	CL
		ADD	AL,0x30
		MOV	[ES:DI],AL
		ADD	DI,2
		ADD	AH,0x30
		MOV	[ES:DI],AH
		ADD	DI,2
		MOV	AL,':'
		MOV	[ES:DI],AL
		ADD	DI,2	
		DEC	SI		;指向分
		MOV	AL,[DS:SI]	;取出分
		MOV	AH,0		;扩展成16位
		DIV	CL
		ADD	AL,0x30
		MOV	[ES:DI],AL
		ADD	DI,2
		ADD	AH,0x30
		MOV	[ES:DI],AH
		ADD	DI,2
		MOV	AL,':'
		MOV	[ES:DI],AL
		ADD	DI,2	
		DEC	SI		;指向秒
		MOV	AL,[DS:SI]	;取出秒
		MOV	AH,0		;扩展成16位
		DIV	CL
		ADD	AL,0x30
		MOV	[ES:DI],AL
		ADD	DI,2
		ADD	AH,0x30
		MOV	[ES:DI],AH
		ADD	DI,2
		MOV	AL,':'
		MOV	[ES:DI],AL
		ADD	DI,2	
		DEC	SI		;指向毫秒
		MOV	AL,[DS:SI]	;取出毫秒
		MOV	AH,0		;扩展成16位
		DIV	CL
		ADD	AL,0x30
		MOV	[ES:DI],AL
		ADD	DI,2
		ADD	AH,0x30
		MOV	[ES:DI],AH
		ADD	DI,2
		MOV	AL,']'
		MOV	[ES:DI],AL
		POP	ES
		POP	DS
		POP	DI
		POP	SI
		POP	CX
		POP	AX
		IRET
_initIRQ1C:	;初始化系统时间区和INT 0x1C中断向量
		PUSH	DS
		PUSH	SI
		PUSH	AX
		MOV	AX,0
		MOV	DS,AX
		MOV	SI,400
		MOV	AX,0
		MOV	[DS:SI],AX
		ADD	SI,2
		MOV	[DS:SI],AX
		MOV	SI,0x1C*4
		MOV	AX,printtime
		MOV	[DS:SI],AX
		ADD	SI,2
		MOV	AX,0x1000
		MOV	[DS:SI],AX
		POP	AX
		POP	SI
		POP	DS
		DB	0x66
		RET
_printIVT:	;在屏幕光标位置打印前30个中断向量
		PUSH	AX
		PUSH	BX
		PUSH	CX
		PUSH	DX
		PUSH	ES
		PUSH	SI
		MOV	AX,0
		MOV	ES,AX
		MOV	SI,0
loop5:		MOV	CL,4
loop1:		MOV	DH,byte [ES:SI]
		CALL	printbyte16
		MOV	AH,0x0e
		MOV	AL,' '
		INT	0x10		
		INC	SI
		DEC	CL
		JNZ	loop1
		MOV 	CL,8
		MOV	AH,0x0e
		MOV	AL,' '
loop2:		INT	0x10
		DEC	CL
		JNZ	loop2
		CMP	SI,119
		JBE	loop5
		POP	SI
		POP	ES
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		DB	0x66
		RET	
printbyte16:	;在屏幕光标位置以16进制显示DH中值
		PUSH	CX
		MOV	AH,0x0e
		MOV	DL,DH
		MOV	CL,4
		SHR	DH,CL
		CMP	DH,09
		JBE	loop3
		ADD	DH,7
loop3:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		MOV	DH,DL
		AND	DH,0x0f
		CMP	DH,09
		JBE	loop4
		ADD	DH,7
loop4:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		POP	CX				
		RET
