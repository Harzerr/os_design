	[BITS	16]
	GLOBAL  _mygetc
	GLOBAL  _ascandsyscode;��ӡ����ASCII���ϵͳɨ����ĺ���
	EXTERN  __sysscancode
_mygetc:;��������ʽ��ȡһ������ֵ
		PUSH	SI
		MOV	AH,0x10
		INT	0x16	;����ʽ��ȡһ������ֵ
		LEA     SI,__sysscancode
		MOV	[SI],AH
		POP	SI
		DB	0x66
		RET
_ascandsyscode:	JMP	continue;��ӡ������ASCII���ϵͳɨ����
continue:	MOV	AH,0x10
		INT	0x16    ;�Ӽ��̻�������ȡ��ֵ
		MOV	DH,AH
		CALL 	print16  ;�ȴ�ӡϵͳɨ����
		MOV	DH,AL
		CALL	print16  ;�ٴ�ӡASCII��
		MOV	AH,0x0e
		MOV	BL,0x07
		MOV	AL,' '
		INT	0x10     ;��ӡһ���ո�
		JMP	continue
print16:	PUSH	AX      ;����һ��AX
		MOV	AH,0x0e
		MOV	BL,0x07
		MOV	DL,DH   ;Ҫ��ӡ���ֽ���DH
		MOV	CL,4
		SHR	DH,CL   ;�ȴ�ӡ��4λ
		CMP	DH,09
		JBE	loop1   ; ���0~9��ֻ��0x30
		ADD	DH,7     ;������A~F�����һ��7
loop1:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		MOV	DH,DL  ;�ٴ�ӡ��4λ
		AND	DH,0x0f
		CMP	DH,09
		JBE	loop2
		ADD	DH,7
loop2:		ADD	DH,0x30
		MOV	AL,DH
		INT	0x10
		POP	AX	;�ָ�AX
		RET









