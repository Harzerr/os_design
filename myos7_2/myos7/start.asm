		[BITS	16]
		GLOBAL	start
		EXTERN	__mymain
start:		JMP	entry
entry:		MOV	AX,CS
		MOV	DS,AX
		MOV	ES,AX
		MOV	AX,0
		MOV	SS,AX
		MOV	SP,0x7e00
		LEA	SI,msg
loop1:		LODSB
		CMP	AL,0
		JE	fin
		MOV	AH,0x0e
		MOV	BX,0x0f
		INT	0x10
		JMP	loop1
fin:		JMP	__mymain
msg:		DB	"myos is running!-start.asm",0x0a,0x0a,0x0a,0
