		ORG		0x7c00
start:		JMP		entry
entry:		MOV		AX,CS
		MOV		SS,AX
		MOV		DS,AX
		MOV		ES,AX
		MOV		SP,0x7c00
		MOV		SI,msg
putloop:	MOV		AL,[SI]
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e
		MOV		BX,0x0f
		INT		0x10
		JMP		putloop
fin:	MOV		AX,0x1000
		MOV		ES,AX
		MOV		BX,0	; �����ڴ�0x10000��
		MOV		AH,0x02	; AH=0x02 : ������
		MOV		DL,0x00	; ��A������		
		MOV		CH,0	; ����0
		MOV		DH,0	; ��ͷ0
		MOV		CL,2	; �ӵ�2��������ʼ��
		MOV		AL,40	; ��40������
		INT		0x13	; ����BIOS
		MOV		AX,0x1000
		PUSH		AX
		MOV		AX,0x000
		PUSH		AX
		RETF		
msg:		DB		"hello, world!-MBR",0x0a,0x0a,0x0a
marker:		TIMES		(0x01fe-marker+start) DB 0
		DB		0x55, 0xaa
