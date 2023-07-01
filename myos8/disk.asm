GLOBAL _writedisk
GLOBAL _readdisk
;EXTERN  __text:byte
GLOBAL vstr
GLOBAL vlen


[BITS 16]
_writedisk:
	PUSH BP
	MOV BP, SP
	MOV BX,[BP+6]
	MOV AX,0X1000
	MOV ES,AX
	MOV AH,0X03
	MOV DL,0X00
	MOV CH, 0
	MOV DH,0
	MOV CL, 10; ��д�������Ŵ�1��Ϊ10
	MOV AL, 1
	INT 0X13
	POP BP
	DB 0X66
	RET
_readdisk:
		PUSHA
		MOV		AX,0x1000
		MOV		ES,AX	; �����ڴ�0x10000��
		MOV		BX,0	
		MOV		AH,0x02	; AH=0x02 : ������
		MOV		DL,0x00	; ��A������		
		MOV		CH,0	; ����0
		MOV		DH,0	; ��ͷ0
		MOV		CL,10	; �ӵ�10��������ʼ��
		MOV		AL,1	; ��1������
		INT		0x13	; ����BIOS
		MOV SI, vstr
		MOV DI, ES:[BX]
		MOV CX, 512
		CLD	
		REP MOVSB	
		
		POPA
		RET
		

vstr	db "MBRMBR",0     ; ����һ�������β���ַ���
vlen    dd    $ - vstr
