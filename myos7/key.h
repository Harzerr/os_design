__asm__(".code16gcc\n");
extern int cursorleft();
extern int cursorright();
extern int ascandsyscode();
char _sysscancode;
#define enterkey 0x0d
#define sysscanleft 0x4b
#define sysscanright 0x4d
#define sysscandelete 0x53
#define sysscanbackspace 0x0e
#include "myos.h"