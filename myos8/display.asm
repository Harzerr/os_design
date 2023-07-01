		[BITS	16]
		GLOBAL  _puts
		GLOBAL  _setmode
		GLOBAL  _initdisp
		GLOBAL  _prompt
		GLOBAL  _myputc
		GLOBAL  _enter
		GLOBAL  _cursorleft
		GLOBAL  _cursorright
		GLOBAL  _timecmdd
		
_puts:		;�ڵ�ǰ���λ�ô�ӡ�����ַ���
		PUSH bp
		MOV	BP,SP
		MOV	SI,[BP+0x06]
loop1:	LODSB
		CMP	AL,0
		JZ	loop2
		MOV	AH,0x0e
		MOV	BH,0x00
		INT	0x10
		JMP	loop1
loop2:	POP BP
		DB	0x66
		RET

_setmode:	;������ʾģʽ
		MOV	BP,SP
		MOV	AL,[BP+0x04]
		MOV  	AH,0x00
		INT  	0x10
		DB   	0x66
		RET

_initdisp:	;��ʼ����Ļ
		MOV	AX,0xb800
		MOV	ES,AX
		MOV	SI,1
loop3:		MOV	byte [ES:SI],0x0c
		ADD	SI,2
		CMP	SI,4000
		JL	loop3	;�ȸ�ֵ��Ļ��ÿ���ַ���ǰ����ɫ
		MOV	SI,0
		MOV	byte [ES:SI],0xc9
loop4:		ADD	SI,2
		MOV	byte [ES:SI],0xcd
		CMP	SI,156
		JNZ	loop4
		ADD	SI,2
		MOV	byte [ES:SI],0xbb
		MOV	SI,160
loop5:		MOV	byte [ES:SI],0xba
		ADD	SI,160
		CMP	SI,160*24
		JNZ	loop5
		MOV	SI,318
loop6:		MOV	byte [ES:SI],0xba
		ADD	SI,160
		CMP	SI,158+160*24
		JNZ	loop6
		MOV	SI,3840
		MOV	byte [ES:SI],0xc8
loop7:		ADD	SI,2
		MOV	byte [ES:SI],0xcd
		CMP	SI,3998
		JNZ	loop7
		MOV	byte [ES:SI],0xbc
		MOV	AH,0x02	;���ù��λ��
		MOV	BH,0x00
		MOV	DX,0x0101
		INT	0x10
		MOV	AH,0x01	;���ù����״
		MOV	CX,0x0607
		INT	0x10
		DB	0x66
		RET

_prompt:	;�ڵ�ǰ���λ����ʾ������ʾ��
		MOV	AH,0x0e
		MOV	BH,0x00
		MOV	AL,'A'
		INT	0x10
		MOV	AL,':'
		INT	0x10
		MOV	AL,'>'
		INT	0x10
		DB	0x66
		RET
_timecmdd:	;�ڵ�ǰ���λ����ʾһ���ַ�����ֵ
		PUSH	AX
		PUSH	CX
		PUSH	SI
		PUSH	DS
		LEA	SI,403
		MOV	AX,0
		MOV	DS,AX
		MOV	CL,10
		MOV	AL,[DS:SI]	;ȡ��ʱ
		MOV	AH,0		;��չ��16λ
		DIV	CL
		ADD	AL,0x30
		MOV CH, AH
		MOV	AH,0x0e
		MOV	BH,0x00
		INT	0x10
		ADD CH,0x30
		MOV AL, CH
		INT 0x10
		MOV	AL,':'
		INT	0x10
		DEC	SI		;ָ����
		MOV	AL,[DS:SI]	;ȡ����
		MOV	AH,0		;��չ��16λ
		DIV	CL
		ADD	AL,0x30
		MOV CH, AH
		MOV	AH,0x0e
		MOV	BH,0x00
		INT	0x10
		ADD CH,0x30
		MOV AL, CH
		INT 0x10
		MOV	AL,':'
		INT	0x10
		DEC	SI		;ָ�����
		MOV	AL,[DS:SI]	;ȡ������
		MOV	AH,0		;��չ��16λ
		DIV	CL
		ADD	AL,0x30
		MOV CH, AH
		MOV AH, 0x0e
		MOV BH, 0x00
		INT 0x10
		ADD CH,0x30
		MOV AL, CH
		INT 0x10

		POP	DI
		POP	SI
		POP	CX
		POP	AX
		DB	0x66
		RET
_myputc:	;�ڵ�ǰ���λ����ʾһ���ַ�����ֵ
		PUSH	BP
		MOV	BP,SP
		MOV	AL,[BP+0x06]
		MOV	AH,0x0e
		MOV	BH,0x00
		INT	0x10
		POP	BP
		DB	0x66
		RET

_enter:		MOV	AH,0x03
		MOV	BH,0x00
		INT	0x10	;��ȡ���λ��
		CMP	DH,23
		JNZ	loop8	;�������һ�У�ֱ��������λ��
		MOV	AX,0x0601 ;�����һ�У������Ϲ���һ��
		MOV	BH,0x0c
		MOV	CX,0x0101;���Ͻ�1��1��
		MOV	DX,0x174e;���½�23��78��
		INT     0x10
		MOV	DH,23
		JMP	loop9
loop8:		INC	DH	;�к���1
loop9:		MOV	DL,0x01	;�кŻص����ף��ܿ���߿�
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;���ù��λ��		
		DB	0x66
		RET

_cursorleft:	MOV	AH,0x03
		MOV	BH,0x00
		INT	0x10	;��ȡ���λ��
		CMP	DL,0x01
		JZ	loop10	;������ߣ�����
		DEC	DL	;�кż�1
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;���ù��λ��
loop10:		DB	0x66
		RET

_cursorright:	MOV	AH,0x03
		MOV	BH,0x00
		INT	0x10	;��ȡ���λ��
		CMP	DL,78
		JZ	loop11	;�����ұߣ�����
		INC	DL	;�кż�1
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;���ù��λ��
loop11:		DB	0x66
		RET


