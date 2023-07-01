ORG 0x7c00
start: JMP entry
entry: MOV AX,0
MOV SS,AX
MOV DS,AX
MOV ES,AX
MOV SP,0x7c00
MOV SI,msg
putloop: MOV AL,[SI]
ADD SI,1
CMP AL,0
JE fin
MOV AH,0x0e
MOV BX,0x0f
INT 0x10
JMP putloop
fin: MOV AX,0x1000 ;
MOV ES,AX ;
MOV BX,0 ; 读到内存 0x10000 处
MOV AH,0x02 ; AH=0x02，读磁盘
MOV DL,0x00 ; A 驱动器
MOV CH,0 ; 柱面 0
MOV DH,0 ; 磁头 0
MOV CL,2 ; 扇区 2
MOV AL,40 ; 共读 1 个扇区
INT 0x13 ; 调用 BIOS
jmp 0x1000:0x0
msg: DB "hello, world!",0x0a,0x0a,0x0a
marker: TIMES (0x01fe-marker+start) DB 0
DB 0x55, 0xaa