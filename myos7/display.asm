[BITS 16]
GLOBAL _puts
GLOBAL _setmode
GLOBAL _initdisplay
GLOBAL _prompt
GLOBAL _myputc
GLOBAL _enter
GLOBAL _cursorleft
GLOBAL _cursorright
GLOBAL _gettimer
_gettimer:
	CALL get_time
	CALL print_time
get_time:
  ;设置BIOS中断0x1A，功能号0x02，获取系统时间
  mov ah, 0x02
  int 0x1A
  
  ;将时分秒存入内存中
  mov byte [time_hour], ch
  mov byte [time_minute], cl
  mov byte [time_second], dh
  
  ret
print_time:
  ;设置光标位置
  mov dx, 0x184F
  ;显示时间
  mov si, time_format
  call print_string
  mov al, byte [time_hour]
  call print_hex
  mov si, colon
  call print_string
  mov al, byte [time_minute]
  call print_hex
  mov si, colon
  call print_string
  mov al, byte [time_second]
  call print_hex 
  
  ;结束
  ret

  print_hex:
  ;将byte类型的16进制数分解为十位和个位
  mov bl, al
  shr bl, 4
  add bl, 0x30
  mov byte [hex_string], bl
  mov bl, al
  and bl, 0x0F
  add bl, 0x30
  mov byte [hex_string+1], bl
 
  ;输出十位和个位
  mov si, hex_string
  call print_string
  
  ;结束
  ret
 
 hex_string db "00" , 0
 time_format db "Time:", 0
 colon db ":", 0
 pos db 0x4f
 time_hour db 0
 time_minute db 0
 time_second db 0
 time 510-($-$$) db 0
 dw 0xAA55

_cursorleft: ;当前光标向左移动一个位置
 MOV AH,0x03
MOV BH,0x00
INT 0x10 ;读取光标位置
CMP DL,0x01
JZ loop10 ;在最左边，不移
DEC DL ;列号减 1
MOV AH,0x02
MOV BH,0x00
INT 0x10 ;设置光标位置
loop10: DB 0x66
RET
_cursorright:;当前光标向右移动一个位置
 MOV AH,0x03
MOV BH,0x00
INT 0x10 ;读取光标位置
CMP DL,78
JZ loop111 ;在最右边，不移
INC DL ;列号加 1
MOV AH,0x02
MOV BH,0x00
INT 0x10 ;设置光标位置
loop111: DB 0x66
RET

_puts: 
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
_prompt: 
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
	JL loop3 
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
	MOV AH,0x02 ;���ù��λ��
	MOV BH,0x00
	MOV DX,0x0101
	INT 0x10
	MOV AH,0x01 ;���ù����״
	MOV CX,0x0607
	INT 0x10
	DB 0x66
	RET

_setmode:;������ʾģʽ 3
MOV BP,SP
MOV AL,[BP+0x04]
MOV AH,0x00
INT 0x10
DB 0x66
RET

_myputc:
	PUSH BP
	MOV BP,SP
	MOV AL,[BP+0x06]
	MOV AH,0x0e
	MOV BH,0x00
	INT 0x10
	POP BP
	DB 0x66
	RET


_enter: 
MOV AH,0x03
MOV BH,0x00
INT 0x10 ;读取光标位置
CMP DH,23
JNZ loop88 ;不是最后一行，直接设置新位置
MOV AX,0x0601 ;是最后一行，先向上滚动一行
MOV BH,0x0c
MOV CX,0x0101;左上角 1 行 1 列
MOV DX,0x174e;右下角 23 行 78 列
INT 0x10
MOV DH,23
JMP loop99
loop88: INC DH ;行号增 1
loop99: MOV DL,0x01 ;列号回到行首，避开左边框
MOV AH,0x02
MOV BH,0x00
INT 0x10 ;设置光标位置
DB 0x66
RET