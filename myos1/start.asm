start: JMP entry
entry: MOV AX,CS
MOV DS,AX
MOV ES,AX
MOV AX,0
MOV SS,AX
MOV SP,0x7e00
LEA SI,msg
putloop: LODSB
CMP AL,0
JE fin
MOV AH,0x0e
MOV BX,0x0f
INT 0x10
JMP putloop
fin: HLT
JMP fin
msg: DB "myos is running!"
DB 0x0a,0x0a,0x0a,0
