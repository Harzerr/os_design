[BITS 16]
GLOBAL _puts
GLOBAL _setmode
GLOBAL _initdisplay
GLOBAL _prompt
GLOBAL _myputc:
_puts: ;在屏幕光标位置打印参数字符串
	MOV BP,SP
	MOV SI,[BP+0x04]
	loopp: LODSB
	CMP AL,0
	JZ loopppp
	MOV AH,0x0e
	MOV BL,0x07
	INT 0x10
	JMP loopp
	loopppp: DB 0x66
	RET
_prompt: ;在光标处显示命令提示符
	MOV AH,0x0e
	MOV AL,'A'
	INT 0x10
	MOV AL,':'
	INT 0x10
	MOV AL,'>'
	INT 0x10
	DB 0x66
	RET

_initdisplay:
	MOV AX,0xb800
	MOV ES,AX
	MOV SI,1
	loop3: MOV byte [ES:SI],0x0e
	ADD SI,2
	CMP SI,4000
	JL loop3 ;先赋值屏幕上每个字符的前背景色
	MOV SI,0
	MOV byte [ES:SI],0xc9
	loop4: ADD SI,2
	MOV byte [ES:SI],0xc4
	CMP SI,156
	JNZ loop4
	ADD SI,2
	MOV byte [ES:SI],0xbb
	MOV SI,160
	loop5: MOV byte [ES:SI],0xb3
	ADD SI,160
	CMP SI,160*24
	JNZ loop5
	MOV SI,318
	loop6: MOV byte [ES:SI],0xb3
	ADD SI,160
	CMP SI,158+160*24
	JNZ loop6
	MOV SI,3840
	MOV byte [ES:SI],0xc8
	loop7: ADD SI,2
	MOV byte [ES:SI],0xc4
	CMP SI,3998
	JNZ loop7
	MOV byte [ES:SI],0xbc
	MOV AH,0x02 ;设置光标位置
	MOV BH,0x00
	MOV DX,0x0101
	INT 0x10
	MOV AH,0x01 ;设置光标形状
	MOV CX,0x0607
	INT 0x10
	DB 0x66
	RET

_setmode:;设置显示模式 3
MOV BP,SP
MOV AL,[BP+0x04]
MOV AH,0x00
INT 0x10
DB 0x66
RET

_myputc:
	mov bp, sp
	mov al, [bp+0x04]
	mov ah, 0x0e
	mov bl, 0x07
	int 0x10
	db 0x66
	ret