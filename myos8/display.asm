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
		
_puts:		;在当前光标位置打印参数字符串
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

_setmode:	;设置显示模式
		MOV	BP,SP
		MOV	AL,[BP+0x04]
		MOV  	AH,0x00
		INT  	0x10
		DB   	0x66
		RET

_initdisp:	;初始化屏幕
		MOV	AX,0xb800
		MOV	ES,AX
		MOV	SI,1
loop3:		MOV	byte [ES:SI],0x0c
		ADD	SI,2
		CMP	SI,4000
		JL	loop3	;先赋值屏幕上每个字符的前背景色
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
		MOV	AH,0x02	;设置光标位置
		MOV	BH,0x00
		MOV	DX,0x0101
		INT	0x10
		MOV	AH,0x01	;设置光标形状
		MOV	CX,0x0607
		INT	0x10
		DB	0x66
		RET

_prompt:	;在当前光标位置显示命令提示符
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
_timecmdd:	;在当前光标位置显示一个字符，传值
		PUSH	AX
		PUSH	CX
		PUSH	SI
		PUSH	DS
		LEA	SI,403
		MOV	AX,0
		MOV	DS,AX
		MOV	CL,10
		MOV	AL,[DS:SI]	;取出时
		MOV	AH,0		;扩展成16位
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
		DEC	SI		;指向秒
		MOV	AL,[DS:SI]	;取出秒
		MOV	AH,0		;扩展成16位
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
		DEC	SI		;指向毫秒
		MOV	AL,[DS:SI]	;取出毫秒
		MOV	AH,0		;扩展成16位
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
_myputc:	;在当前光标位置显示一个字符，传值
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
		INT	0x10	;读取光标位置
		CMP	DH,23
		JNZ	loop8	;不是最后一行，直接设置新位置
		MOV	AX,0x0601 ;是最后一行，先向上滚动一行
		MOV	BH,0x0c
		MOV	CX,0x0101;左上角1行1列
		MOV	DX,0x174e;右下角23行78列
		INT     0x10
		MOV	DH,23
		JMP	loop9
loop8:		INC	DH	;行号增1
loop9:		MOV	DL,0x01	;列号回到行首，避开左边框
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;设置光标位置		
		DB	0x66
		RET

_cursorleft:	MOV	AH,0x03
		MOV	BH,0x00
		INT	0x10	;读取光标位置
		CMP	DL,0x01
		JZ	loop10	;在最左边，不移
		DEC	DL	;列号减1
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;设置光标位置
loop10:		DB	0x66
		RET

_cursorright:	MOV	AH,0x03
		MOV	BH,0x00
		INT	0x10	;读取光标位置
		CMP	DL,78
		JZ	loop11	;在最右边，不移
		INC	DL	;列号加1
		MOV	AH,0x02
		MOV	BH,0x00
		INT	0x10	;设置光标位置
loop11:		DB	0x66
		RET


