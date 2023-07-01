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
		MOV	SI,400		;ָ�����
		MOV	AL,[DS:SI]	;ȡ������
		INC	AL		;������1
		MOV	[DS:SI],AL	;�ͻ�ȥ
		CMP	AL,20		;��1����		
		JL	loop0		;������ֱ����ʾ
		MOV	AL,0		;��1�룬��������
		MOV	[DS:SI],AL
		INC	SI		;ָ����
		MOV	AL,[DS:SI]	;ȡ����
		INC	AL		;����1
		MOV	[DS:SI],AL	;�ͻ�ȥ
		CMP	AL,60		;��1����
		JL	loop0		;������ֱ����ʾ
		MOV	AL,0		;��1�֣�������
		MOV	[DS:SI],AL
		INC	SI		;ָ���
		MOV	AL,[DS:SI]	;ȡ����
		INC	AL		;����1
		MOV	[DS:SI],AL	;�ͻ�ȥ
		CMP	AL,60		;��1ʱ��	
		JL	loop0		;������ֱ����ʾ
		MOV	AL,0		;��1ʱ��������
		MOV	[DS:SI],AL
		INC	SI		;ָ��ʱ
		MOV	AL,[DS:SI]	;ȡ��ʱ
		INC	AL		;ʱ��1		
		MOV	[DS:SI],AL	;�ͻ�ȥ
		CMP	AL,24		;��1����
		JL	loop0		;������ֱ����ʾ
		MOV	AL,0		;��1�죬ʱ����
		MOV	[DS:SI],AL	
loop0:	MOV	DI,3972		;��ʼ��ʾ
		LEA	SI,403
		MOV	CL,10
		MOV	AL,'['		;����ʾ������
		MOV	[ES:DI],AL
		ADD	DI,2
		MOV	AL,[DS:SI]	;ȡ��ʱ
		MOV	AH,0		;��չ��16λ
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
		DEC	SI		;ָ���
		MOV	AL,[DS:SI]	;ȡ����
		MOV	AH,0		;��չ��16λ
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
		DEC	SI		;ָ����
		MOV	AL,[DS:SI]	;ȡ����
		MOV	AH,0		;��չ��16λ
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
		DEC	SI		;ָ�����
		MOV	AL,[DS:SI]	;ȡ������
		MOV	AH,0		;��չ��16λ
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
_initIRQ1C:	;��ʼ��ϵͳʱ������INT 0x1C�ж�����
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
_printIVT:	;����Ļ���λ�ô�ӡǰ30���ж�����
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
printbyte16:	;����Ļ���λ����16������ʾDH��ֵ
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
