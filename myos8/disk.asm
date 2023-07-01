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
	MOV CL, 10; 将写入扇区号从1改为10
	MOV AL, 1
	INT 0X13
	POP BP
	DB 0X66
	RET
_readdisk:
		PUSHA
		MOV		AX,0x1000
		MOV		ES,AX	; 读到内存0x10000处
		MOV		BX,0	
		MOV		AH,0x02	; AH=0x02 : 读磁盘
		MOV		DL,0x00	; 读A驱动器		
		MOV		CH,0	; 柱面0
		MOV		DH,0	; 磁头0
		MOV		CL,10	; 从第10个扇区开始读
		MOV		AL,1	; 读1个扇区
		INT		0x13	; 调用BIOS
		MOV SI, vstr
		MOV DI, ES:[BX]
		MOV CX, 512
		CLD	
		REP MOVSB	
		
		POPA
		RET
		

vstr	db "MBRMBR",0     ; 定义一个以零结尾的字符串
vlen    dd    $ - vstr
